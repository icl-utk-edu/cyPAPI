# File contains declarations from the header file papi.h 
cdef extern from 'papi.h':
    # Section for PAPI #define's
    cdef int PAPI_NULL
    ## PAPI error codes
    cdef int PAPI_OK                                                            
    cdef int PAPI_EINVAL                                                        
    cdef int PAPI_ENOMEM                                                        
    cdef int PAPI_ENOEVNT                                                       
    cdef int PAPI_ENOCMP                                                        
    cdef int PAPI_EISRUN                                                        
    cdef int PAPI_EDELAY_INIT
    ## PAPI string lengths
    cdef int PAPI_MAX_STR_LEN
    cdef int PAPI_MIN_STR_LEN
    cdef int PAPI_HUGE_STR_LEN
    ## PAPI array lengths
    cdef int _PAPI_PMU_MAX "PAPI_PMU_MAX"
    cdef int _PAPI_MAX_INFO_TERMS "PAPI_MAX_INFO_TERMS"
    ## Option's for PAPI_get_opt
    cdef int PAPI_CLOCKRATE

    # Section for PAPI functions related to initialization and shutdown
    ## Initialization
    int PAPI_library_init(int version)
    int PAPI_is_initialized()
    ## Versioning
    int _PAPI_VER_CURRENT "PAPI_VER_CURRENT"
    int _PAPI_VERSION "PAPI_VERSION"
    ## Shutdown 
    void PAPI_shutdown()

    # Section for PAPI functions related to timer's
    ## Real timers
    long long PAPI_get_real_cyc()                                               
    long long PAPI_get_real_nsec()                                              
    long long PAPI_get_real_usec()
    ## Virtual timers                                            
    long long PAPI_get_virt_cyc()                                               
    long long PAPI_get_virt_nsec()                                              
    long long PAPI_get_virt_usec() 

    # Section for PAPI functions related to event sets 
    int PAPI_create_eventset(int *EventSet)
    int PAPI_cleanup_eventset(int EventSet)                                     
    int PAPI_destroy_eventset(int *EventSet)                                    
    int PAPI_state(int EventSet, int *status)
    ## Getting event set info                                     
    int PAPI_num_events(int EventSet)
    int PAPI_list_events(int EventSet, int *Events, int *number)
    ## Component related                
    int PAPI_assign_eventset_component(int EventSet, int cidx)
    int PAPI_get_eventset_component(int EventSet)                  
    int PAPI_reset(int EventSet)
    ## Adding events                                                
    int PAPI_add_event(int EventSet, int Event)                                 
    int PAPI_add_named_event(int EventSet, const char *EventName)
    ## Removing events
    int PAPI_remove_event(int EventSet, int EventCode)
    ## Counting hardware events               
    int PAPI_start(int EventSet)                                                
    int PAPI_stop(int EventSet, long long * values)                             
    int PAPI_read(int EventSet, long long * values)                             
    int PAPI_read_ts(int EventSet, long long * values, long long *cyc)          
    int PAPI_accum(int EventSet, long long * values)                            
    int PAPI_write(int EventSet, long long * values)                            

    # Section for PAPI functions related to the components
    int PAPI_num_cmp_hwctrs(int cidx)
    int PAPI_num_components()
    int PAPI_enum_cmp_event(int *EventCode, int modifier, int cidx)
    int PAPI_get_component_index(const char *name)

    # Section for PAPI functions related to events
    int PAPI_query_event(int EventCode)                                       
    int PAPI_query_named_event(const char *EventName)
    int PAPI_enum_event(int *EventCode, int modifier)                           
    int PAPI_event_code_to_name(int EventCode, char *out)                       
    int PAPI_event_name_to_code(const char *in_, int *out)

    # Section for PAPI functions related to error codes
    char *PAPI_strerror(int) 

    # Section for PAPI modifiers
    ## Generic PAPI modifiers
    cdef int _PAPI_ENUM_FIRST "PAPI_ENUM_FIRST"
    cdef int _PAPI_ENUM_EVENTS "PAPI_ENUM_EVENTS"
    cdef int _PAPI_ENUM_ALL "PAPI_ENUM_ALL"
    ## Preset PAPI modifiers
    cdef int _PAPI_PRESET_ENUM_AVAIL "PAPI_PRESET_ENUM_AVAIL"
    ## Native PAPI modifiers
    cdef int _PAPI_NTV_ENUM_UMASKS "PAPI_NTV_ENUM_UMASKS"
    cdef int _PAPI_NTV_ENUM_UMASK_COMBOS "PAPI_NTV_ENUM_UMASK_COMBOS"

    # Section related to PAPI structures
    ## Functions that fill PAPI structures
    int PAPI_get_event_info(int EventCode, PAPI_event_info_t * info)
    const PAPI_component_info_t *PAPI_get_component_info(int cidx)
    int PAPI_get_opt(int option, void *ptr)
    ## Defined structures and member variables
    ctypedef struct PAPI_component_info_t:
        char* name                                 # Name of the component we're using
        char* short_name                           # Short name of component, to be prepended to event names
        char* description                          # Description of the component
        char* version                              # Version of this component
        char* support_version                      # Version of the support library
        char* kernel_version                       # Version of the kernel PMC support driver
        char* disabled_reason                      # Reason for failure of initialization
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
        char *pmu_names[80]                        # List of pmu names supported by this component
        int reserved[8]                            # Reserved
        unsigned int hardware_intr                 # Hw overflow intr, does not need to be emulated in software
        unsigned int precise_intr                  # Performance interruprs happen precisely
        unsigned int posix1b_timers                # Using POSIX 1b internal timers (timer_create) instead of setitimer
        unsigned int kernel_profile                # Has kernel profiling support (buffered interrupts or sprofil-like)
        unsigned int kernel_multiplex              # In kernel multiplexing
        unsigned int fast_counter_read             # Supports a user level PMC read instruction
        unsigned int fast_real_timer               # Supports a fast real timer
        unsigned int fast_virtual_timer            # Supports a fast virtual timer
        unsigned int attach                        # Supports attach
        unsigned int attach_must_ptrace            # Attach must first ptrace and stop the thread/process
        unsigned int cntr_umasks                   # Counters have unit masks
        unsigned int cpu                           # Supports specifying cpu number to use with eventset
        unsigned int inherit                       # Supports child processes inheriting parents counters
        unsigned int reserved_bits
    ctypedef struct PAPI_event_info_t:
        unsigned int event_code;    # Preset or Native event code
        char* symbol;               # Name of the event
        char* short_descr;          # Short description suitable for use as a label
        char* long_descr;           # Longer description, typically a sentence
        int component_index;        # Component event belongs to
        char* units;                # Units event is measured in
        int location;               # Location event applies to
        int data_type;              # Data type returned by PAPI
        int value_type;             # Sum or absolute
        int timescope;              # From start, etc.
        int update_type;            # How event is updated
        int update_freq;            # How frequently event is updated
        # PRESET SPECIFIC FIELDS FOLLOW
        unsigned int count;         # Number of terms in the code and name fields
        unsigned int event_type;    # Event type or category for preset events only
        char* derived;              # Name of the derived type
        char* postfix;              # String containing postfix operations
        unsigned int code[12]       # Array of values that further describe the event
        char name[12][256]          # Names of code terms
        char *note                  # An optional developer note
