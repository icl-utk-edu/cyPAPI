from libc.stdint cimport uint32_t
cdef extern from 'sde_lib.h':
    int PAPI_SDE_VERSION

    cdef int SDE_OK

    cdef int PAPI_SDE_RO
    cdef int PAPI_SDE_RW
    cdef int PAPI_SDE_DELTA
    cdef int PAPI_SDE_INSTANT

    cdef int PAPI_SDE_long_long
    cdef int PAPI_SDE_double

    cdef int PAPI_SDE_SUM
    cdef int PAPI_SDE_MIN
    cdef int PAPI_SDE_MAX

    ctypedef void* papi_handle_t

    cdef void* papi_sde_init(const char *name_of_library)
    cdef int   papi_sde_shutdown(papi_handle_t handle)
    cdef int   papi_sde_register_counter(
        papi_handle_t handle,
        const char *event_name,
        int cntr_mode,
        int cntr_type,
        void *counter
    )
    cdef int   papi_sde_describe_counter(
        papi_handle_t handle,
        const char *event_name,
        const char *event_description
    )
    cdef int  papi_sde_unregister_counter( void *handle, const char *event_name )
    cdef int  papi_sde_add_counter_to_group(
        papi_handle_t handle,
        const char *event_name,
        const char *group_name,
        uint32_t group_flags
    )
    cdef void *papi_sde_get_counter_handle(papi_handle_t handle, const char *event_name)

    ctypedef long long int (*papi_sde_fptr_t)( void * );
    cdef int papi_sde_register_counter_cb(
        papi_handle_t handle,
        const char *event_name,
        int cntr_mode,
        int cntr_type,
        papi_sde_fptr_t callback,
        void *param
    )
