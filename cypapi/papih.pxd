cdef extern from 'papi.h':
    int PAPI_VER_CURRENT
    int PAPI_VERSION
    int PAPI_VERSION_MAJOR(int)
    int PAPI_VERSION_MINOR(int)
    int PAPI_VERSION_REVISION(int)
    int PAPI_VERSION_INCREMENT(int)
    int PAPI_library_init(int version)
    int PAPI_is_initialized()
    char *PAPI_strerror(int)
    int PAPI_num_components()
    int PAPI_get_component_index(const char *name)
    void  PAPI_shutdown()

    long long PAPI_get_real_cyc()
    long long PAPI_get_real_nsec()
    long long PAPI_get_real_usec()
    long long PAPI_get_virt_cyc()
    long long PAPI_get_virt_nsec()
    long long PAPI_get_virt_usec()
    cdef int PAPI_CLOCKRATE
    int  PAPI_get_opt(int option, void *ptr)

    cdef int PAPI_NATIVE_MASK
    cdef int PAPI_ENUM_FIRST
    cdef int PAPI_ENUM_EVENTS
    cdef int PAPI_MAX_STR_LEN
    cdef int PAPI_MIN_STR_LEN
    cdef int PAPI_HUGE_STR_LEN
    cdef int PAPI_PMU_MAX

    cdef int PAPI_OK
    cdef int PAPI_EINVAL
    cdef int PAPI_ENOMEM
    cdef int PAPI_ENOEVNT
    cdef int PAPI_ENOCMP
    cdef int PAPI_EISRUN
    cdef int PAPI_EDELAY_INIT

    ctypedef struct PAPI_component_info_t:
        char* name                # Name of the component we're using
        char* short_name          # Short name of component, to be prepended to event names
        char* description         # Description of the component
        char* version             # Version of this component
        char* support_version     # Version of the support library
        char* kernel_version      # Version of the kernel PMC support driver
        char* disabled_reason    # Reason for failure of initialization
        int disabled                               # 0 if enabled, otherwise error code from initialization
        int initialized                            # Component is ready to use
        int CmpIdx                                 # Index into the vector array for this component; set at init time
        int num_cntrs                              # Number of hardware counters the component supports
        int num_mpx_cntrs                          # Number of hardware counters the component or PAPI can multiplex supports
        int num_preset_events                      # Number of preset events the component supports
        int num_native_events                      # Number of native events the component supports
        int default_domain                         # The default domain when this component is used
        int available_domains                      # Available domains
        int default_granularity                    # The default granularity when this component is used
        int available_granularities                # Available granularities
        int hardware_intr_sig                      # Signal used by hardware to deliver PMC events
        int component_type                         # Type of component
        char **pmu_names              # List of pmu names supported by this component
        int reserved[8]                            # Reserved

    const PAPI_component_info_t *PAPI_get_component_info(int cidx)

    int PAPI_num_cmp_hwctrs(int cidx)
    cdef int PAPI_PRESET_MASK
    cdef int PAPI_PRESET_ENUM_AVAIL
    cdef int PAPI_PRESET_ENUM_MSC
    cdef int PAPI_PRESET_ENUM_INS
    cdef int PAPI_PRESET_ENUM_IDL
    cdef int PAPI_PRESET_ENUM_BR
    cdef int PAPI_PRESET_ENUM_CND
    cdef int PAPI_PRESET_ENUM_MEM
    cdef int PAPI_PRESET_ENUM_CACH
    cdef int PAPI_PRESET_ENUM_L1
    cdef int PAPI_PRESET_ENUM_L2
    cdef int PAPI_PRESET_ENUM_L3
    cdef int PAPI_PRESET_ENUM_TLB
    cdef int PAPI_PRESET_ENUM_FP
    int PAPI_enum_event(int *EventCode, int modifier)
    int PAPI_enum_cmp_event(int *EventCode, int modifier, int cidx)
    int PAPI_event_code_to_name(int EventCode, char *out)
    int PAPI_event_name_to_code(const char *in_, int *out)

    ctypedef struct PAPI_event_info_t:
        unsigned int event_code;
        char* symbol;
        char* short_descr;
        char* long_descr;
        int component_index;
        char* units;
        int location;
        int data_type;
        int value_type;
        int timescope;
        int update_type;
        int update_freq;
        # PRESET SPECIFIC FIELDS FOLLOW
        unsigned int count;
        unsigned int event_type;
        char* derived;
        char* postfix;

    int PAPI_get_event_info(int EventCode, PAPI_event_info_t * info)

    cdef int PAPI_NULL
    int PAPI_create_eventset(int *EventSet)
    int PAPI_destroy_eventset(int *EventSet)
    int PAPI_cleanup_eventset(int EventSet)
    int PAPI_num_events(int EventSet)
    int PAPI_assign_eventset_component(int EventSet, int cidx)
    int PAPI_reset(int EventSet)
    int PAPI_add_event(int EventSet, int Event)
    int PAPI_add_named_event(int EventSet, const char *EventName)
    int PAPI_start(int EventSet)
    int PAPI_stop(int EventSet, long long * values)
    int PAPI_read(int EventSet, long long * values)
    int PAPI_read_ts(int EventSet, long long * values, long long *cyc)
    int PAPI_accum(int EventSet, long long * values)
    int PAPI_list_events(int EventSet, int *Events, int *number)
    int PAPI_state(int EventSet, int *status)
    int PAPI_write(int EventSet, long long * values)
    int PAPI_get_eventset_component(int EventSet)
