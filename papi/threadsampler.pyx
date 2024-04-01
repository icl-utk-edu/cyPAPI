# cython: language_level=3
import threading
cimport posix.unistd as unistd
from libc.stdlib cimport malloc, free, calloc, realloc
from libc.stdio cimport printf
import warnings
import numpy as np
cimport numpy as np

cdef extern from 'papi.h' nogil:
    cdef int PAPI_OK
    cdef int PAPI_EISRUN
    int PAPI_thread_init(unsigned long (*id_fn) ())
    int PAPI_register_thread()
    int PAPI_unregister_thread()
    int PAPI_num_events(int EventSet)
    int PAPI_read_ts(int EventSet, long long * values, long long *cyc)
    int PAPI_start(int EventSet)
    int PAPI_stop(int EventSet, long long * values)

cdef unsigned long get_thread_id() noexcept nogil:
    with gil:
        return threading.get_native_id()

def pyPAPI_thread_init():
    cdef int papi_errno = PAPI_thread_init(get_thread_id)
    if papi_errno != PAPI_OK:
        raise Exception('PAPI Error: PAPI_thread_init failed')

cdef long int INIT_SIZE = 64

cdef class ThreadSamplerEventSet:
    cdef int evtset_id
    cdef int interval_ms
    cdef object thread
    cdef int stop_event
    cdef long long *values
    cdef long int counter
    cdef long int arrsize
    cdef long long **data

    def __cinit__(self, eventset: object, interval_ms: int):
        self.evtset_id = eventset.get_id()

        self.interval_ms = interval_ms
        self.thread = None
        self.stop_event = 0
        self.values = <long long *> malloc(PAPI_num_events(self.evtset_id) * sizeof(long long))
        self.__init_arr__()

    def __dealloc__(self):
        free(self.values)
        cdef long int i
        for i in range(self.arrsize):
            free(self.data[i])
        free(self.data)

    cdef void __init_arr__(self):
        self.data = <long long **> malloc(INIT_SIZE * sizeof(long long *))
        self.arrsize = INIT_SIZE
        self.counter = 0
        cdef long int i
        for i in range(INIT_SIZE):
            self.data[i] = <long long *> calloc(PAPI_num_events(self.evtset_id) + 1, sizeof(long long))

    cdef void record(self, long long cyc, long long *values) nogil:
        cdef long int i
        if self.counter >= self.arrsize:
            self.arrsize *= 2
            self.data = <long long **> realloc(self.data, self.arrsize * sizeof(long long *))
            for i in range(self.counter, self.arrsize):
                self.data[i] = <long long *> calloc(PAPI_num_events(self.evtset_id) + 1, sizeof(long long))

        self.data[self.counter][0] = cyc
        for i in range(PAPI_num_events(self.evtset_id)):
            self.data[self.counter][i+1] = values[i]
        self.counter += 1

    def start(self):
        if self.thread is not None and self.thread.is_alive():
            self.stop_event = 1
            self.thread.join()
            raise Exception('Thread already running.')

        self.stop_event = 0
        self.thread = threading.Thread(target=self.run)
        self.thread.start()

    cpdef run(self):
        cdef long long cyc = -1
        cdef int papi_errno = PAPI_register_thread()
        if papi_errno != PAPI_OK:
            raise Exception('PAPI Error: PAPI_register thread failed.')

        papi_errno = PAPI_start(self.evtset_id)
        if papi_errno == PAPI_EISRUN:
            warnings.warn('Event set is already running. Ignoring PAPI_start.')
        elif papi_errno != PAPI_OK:
            raise Exception(f'PAPI Error {papi_errno}: PAPI_start failed.')

        with nogil:
            while True:
                if self.stop_event:
                    break

                papi_errno = PAPI_read_ts(self.evtset_id, self.values, &cyc)
                if papi_errno != PAPI_OK:
                    with gil:
                        raise Exception(f'PAPI Error {papi_errno}: PAPI_read_ts failed.')
                self.record(cyc, self.values)
                unistd.usleep(self.interval_ms * 1000)

        papi_errno = PAPI_stop(self.evtset_id, self.values)
        if papi_errno != PAPI_OK:
            raise Exception(f'PAPI Error {papi_errno}: PAPI_stop failed.')

        papi_errno = PAPI_unregister_thread()
        if papi_errno != PAPI_OK:
            raise Exception('PAPI Error: PAPI_unregister_thread failed.')

    def stop(self):
        self.stop_event = 1
        self.thread.join()
        self.thread = None
        return self.__get_data_array__()

    def __get_data_array__(self):
        cdef np.ndarray[np.int64_t, ndim=2] np_data
        np_data = np.zeros((self.counter, PAPI_num_events(self.evtset_id) + 1), dtype=np.int64)
        cdef long int i, j

        for i in range(self.counter):
            for j in range(PAPI_num_events(self.evtset_id) + 1):
                np_data[i, j] = self.data[i][j]

        return np_data

    def reset(self):
        self.counter = 0
