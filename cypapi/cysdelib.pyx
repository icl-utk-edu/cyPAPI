# cython: language_level=3str
import struct

cimport posix.dlfcn as dlfcn

from cypapi.cypapi_exceptions import _exceptions_for_cypapi
from cypapi.sde_libh cimport *

cdef void *libhndl = dlfcn.dlopen('libpapi.so', dlfcn.RTLD_LAZY | dlfcn.RTLD_GLOBAL)

def pack_float_i64(float value):
    """A utility function to pack the bits of a float value into an int."""
    return struct.unpack('q', struct.pack('d', value))[0]

def unpack_i64_float(long long int value):
    """A utility to unpack the bits of a float packed into a long long int."""
    return struct.unpack('d', struct.pack('q', value))[0]

SDE_RO = PAPI_SDE_RO
SDE_INSTANT = PAPI_SDE_INSTANT
SDE_DELTA = PAPI_SDE_DELTA

SDE_SUM = PAPI_SDE_SUM
SDE_MIN = PAPI_SDE_MIN
SDE_MAX = PAPI_SDE_MAX

cdef class _cSdeCounter:
    cdef int cntr_mode
    cdef int cntr_type
    cdef int i_counter
    cdef double d_counter

    def __cinit__(self, int cntr_mode, int cntr_type, init=None):
        self.cntr_mode = cntr_mode
        self.cntr_type = cntr_type
        if init is not None:
            self.value = init

    @property
    def value(self):
        if self.cntr_type == PAPI_SDE_long_long:
            return self.i_counter
        else:
            return self.d_counter
    
    @value.setter
    def value(self, value):
        if self.cntr_type == PAPI_SDE_long_long:
            self.i_counter = value
        else:
            self.d_counter = value

class SdeCounter:
    def __init__(self, event_name: str, cntr_mode: int, cntr_type: type, init=None):
        cdef int _type
        self._name = event_name
        if issubclass(cntr_type, int):
            _type = PAPI_SDE_long_long
        elif issubclass(cntr_type, float):
            _type = PAPI_SDE_double
        else:
            raise ValueError('Invalid counter type requested.')

        self._counter = _cSdeCounter(cntr_mode, _type, init)

    @property
    def value(self):
        return self._counter.value

    @value.setter
    def value(self, value):
        self._counter.value = value

cdef long long int cb_caller(void *py_cb) noexcept:
    try:
        func = <object> py_cb;
        return <long long int> func();
    except:
        return -1

class SdeCounterCB:
    def __init__(self, event_name: str, cntr_mode: int, cntr_type: int, func):
        cdef int _type
        self._name = event_name
        if issubclass(cntr_type, int):
            _type = PAPI_SDE_long_long
        elif issubclass(cntr_type, float):
            _type = PAPI_SDE_double
        else:
            raise ValueError('Invalid counter type requested.')
        
        self._counter = _cSdeCounter(cntr_mode, _type)
        self._pyfunc = func

cdef class _cSdeHandle:
    cdef papi_handle_t handle
    cdef bytes library_name_cstr

    def __cinit__(self, str name_of_library):
        self.library_name_cstr = name_of_library.encode('utf-8')
        self.handle = papi_sde_init(<const char *> self.library_name_cstr)

        if self.handle is NULL:
            raise MemoryError('Failed to initialize SDE internal data-structures.')

    def __repr__(self):
        return f"{self.__class__.__name__}('{str(self.library_name_cstr, encoding='utf-8')}')"

    def shutdown(self):
        cdef int retval = papi_sde_shutdown(self.handle)
        if retval != SDE_OK:
            raise _exceptions_for_cypapi[retval]

    def register_counter(self, str event_name, _cSdeCounter counter):
        cdef void* pctr
        cdef bytes evt_name = event_name.encode('utf-8')
        if counter.cntr_type == PAPI_SDE_long_long:
            pctr = <void *> &counter.i_counter
        else:
            pctr = <void *> &counter.d_counter

        cdef int retval = papi_sde_register_counter(
            self.handle, <const char *> evt_name,
            counter.cntr_mode, counter.cntr_type, pctr
            )
        if retval != SDE_OK:
            raise _exceptions_for_cypapi[retval]

    def register_counter_cb(self, str event_name, _cSdeCounter counter, py_func):
        cdef bytes evt_name = event_name.encode('utf-8')
        cdef int retval = papi_sde_register_counter_cb(
            self.handle, <const char *> evt_name,
            counter.cntr_mode, counter.cntr_type,
            cb_caller, <void *> py_func
        )
        if retval != SDE_OK:
            raise _exceptions_for_cypapi[retval]

    def describe_counter(self, str event_name, str description):
        cdef bytes evt_name = event_name.encode('utf-8')
        cdef bytes descr = description.encode('utf-8')
        cdef int retval = papi_sde_describe_counter(self.handle, <const char*> evt_name, <const char*> descr)
        if retval != SDE_OK:
            raise _exceptions_for_cypapi[retval]

    def unregister_counter(self, str event_name):
        cdef bytes evt_name = event_name.encode('utf-8')
        cdef int retval = papi_sde_unregister_counter(self.handle, <const char *> evt_name)
        if retval != SDE_OK:
            raise _exceptions_for_cypapi[retval]

    def add_counter_to_group(self, str event_name, str group_name, int group_flag):
        cdef bytes evt_name = event_name.encode('utf-8')
        cdef bytes grp_name = group_name.encode('utf-8')
        if group_flag not in (PAPI_SDE_SUM, PAPI_SDE_MAX, PAPI_SDE_MIN):
            raise ValueError('Invalid group flag provided.')
        cdef int retval = papi_sde_add_counter_to_group(self.handle, <const char*> evt_name, <const char *> grp_name, group_flag)
        if retval != SDE_OK:
            raise _exceptions_for_cypapi[retval]

    def get_counter_handle(self, str event_name):
        cdef bytes evt_name = event_name.encode('utf-8')
        cdef void* counter_handle = papi_sde_get_counter_handle(self.handle, <const char *> evt_name)

class SdeHandle:
    def __init__(self, name_of_library: str):
        self._name_of_library = name_of_library
        self._handle = _cSdeHandle(self._name_of_library)
        self._registered_counters = dict()
    
    def __repr__(self):
        return f"{self.__class__.__name__}({self._name_of_library})"

    def __del__(self):
        self._handle.shutdown()

    def register_counter(self, counter):
        if isinstance(counter, SdeCounter):
            self._handle.register_counter(counter._name, counter._counter)
        elif isinstance(counter, SdeCounterCB):
            self._handle.register_counter_cb(counter._name, counter._counter, counter._pyfunc)
        self._registered_counters[counter._name] = counter

    def describe_counter(self, event_name, description):
        self._handle.describe_counter(event_name, description)
