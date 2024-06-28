# cython: language_level=3str
from cpython.mem cimport PyMem_Malloc, PyMem_Realloc, PyMem_Free
import numpy as np
from dataclasses import dataclass, field, InitVar
cimport numpy as np

cimport posix.dlfcn as dlfcn
cdef void *libhndl = dlfcn.dlopen('libsde.so', dlfcn.RTLD_LAZY | dlfcn.RTLD_GLOBAL)

from cypapi_exceptions import _exceptions_for_cypapi
from papih cimport *
from papiStdEventDefh cimport *

# PAPI versioning
PAPI_VER_CURRENT = _PAPI_VER_CURRENT
PAPI_VERSION = _PAPI_VERSION

# lambda functions to obtain PAPI version number; equivalent to C #define
PAPI_VERSION_MAJOR = lambda x: ( <unsigned int>x >> 24 & <unsigned int>0xff )
PAPI_VERSION_MINOR = lambda x: ( <unsigned int>x >> 16 & <unsigned int>0xff )
PAPI_VERSION_REVISION = lambda x: ( <unsigned int>x >> 8 & <unsigned int>0xff )
PAPI_VERSION_INCREMENT = lambda x: ( <unsigned int>x & <unsigned int>0xff )

# importing PAPI preset #defines to be used in cyPAPI
PAPI_L1_DCM = _PAPI_L1_DCM 
PAPI_L1_ICM = _PAPI_L1_ICM 
PAPI_L2_DCM = _PAPI_L2_DCM 
PAPI_L2_ICM = _PAPI_L2_ICM 
PAPI_L3_DCM = _PAPI_L3_DCM 
PAPI_L3_ICM = _PAPI_L3_ICM 
PAPI_L1_TCM = _PAPI_L1_TCM 
PAPI_L2_TCM = _PAPI_L2_TCM 
PAPI_L3_TCM = _PAPI_L3_TCM 
PAPI_CA_SNP = _PAPI_CA_SNP 
PAPI_CA_SHR = _PAPI_CA_SHR 
PAPI_CA_CLN = _PAPI_CA_CLN 
PAPI_CA_INV = _PAPI_CA_INV 
PAPI_CA_ITV = _PAPI_CA_ITV 
PAPI_L3_LDM = _PAPI_L3_LDM 
PAPI_L3_STM = _PAPI_L3_STM 
PAPI_BRU_IDL = _PAPI_BRU_IDL
PAPI_FXU_IDL = _PAPI_FXU_IDL
PAPI_FPU_IDL = _PAPI_FPU_IDL
PAPI_LSU_IDL = _PAPI_LSU_IDL
PAPI_TLB_DM = _PAPI_TLB_DM 
PAPI_TLB_IM = _PAPI_TLB_IM 
PAPI_TLB_TL = _PAPI_TLB_TL 
PAPI_L1_LDM = _PAPI_L1_LDM 
PAPI_L1_STM = _PAPI_L1_STM 
PAPI_L2_LDM = _PAPI_L2_LDM 
PAPI_L2_STM = _PAPI_L2_STM 
PAPI_BTAC_M = _PAPI_BTAC_M 
PAPI_PRF_DM = _PAPI_PRF_DM 
PAPI_L3_DCH = _PAPI_L3_DCH 
PAPI_TLB_SD = _PAPI_TLB_SD 
PAPI_CSR_FAL = _PAPI_CSR_FAL
PAPI_CSR_SUC = _PAPI_CSR_SUC
PAPI_CSR_TOT = _PAPI_CSR_TOT
PAPI_MEM_SCY = _PAPI_MEM_SCY
PAPI_MEM_RCY = _PAPI_MEM_RCY
PAPI_MEM_WCY = _PAPI_MEM_WCY
PAPI_STL_ICY = _PAPI_STL_ICY
PAPI_FUL_ICY = _PAPI_FUL_ICY
PAPI_STL_CCY = _PAPI_STL_CCY
PAPI_FUL_CCY = _PAPI_FUL_CCY
PAPI_HW_INT = _PAPI_HW_INT 
PAPI_BR_UCN = _PAPI_BR_UCN 
PAPI_BR_CN  = _PAPI_BR_CN  
PAPI_BR_TKN = _PAPI_BR_TKN 
PAPI_BR_NTK = _PAPI_BR_NTK 
PAPI_BR_MSP = _PAPI_BR_MSP 
PAPI_BR_PRC = _PAPI_BR_PRC 
PAPI_FMA_INS = _PAPI_FMA_INS
PAPI_TOT_IIS = _PAPI_TOT_IIS
PAPI_TOT_INS = _PAPI_TOT_INS
PAPI_INT_INS = _PAPI_INT_INS
PAPI_FP_INS = _PAPI_FP_INS 
PAPI_LD_INS = _PAPI_LD_INS 
PAPI_SR_INS = _PAPI_SR_INS 
PAPI_BR_INS = _PAPI_BR_INS 
PAPI_VEC_INS = _PAPI_VEC_INS
PAPI_RES_STL = _PAPI_RES_STL
PAPI_FP_STAL = _PAPI_FP_STAL
PAPI_TOT_CYC = _PAPI_TOT_CYC
PAPI_LST_INS = _PAPI_LST_INS
PAPI_SYC_INS = _PAPI_SYC_INS
PAPI_L1_DCH  = _PAPI_L1_DCH 
PAPI_L2_DCH = _PAPI_L2_DCH 
PAPI_L1_DCA = _PAPI_L1_DCA 
PAPI_L2_DCA = _PAPI_L2_DCA 
PAPI_L3_DCA = _PAPI_L3_DCA 
PAPI_L1_DCR = _PAPI_L1_DCR 
PAPI_L2_DCR = _PAPI_L2_DCR 
PAPI_L3_DCR = _PAPI_L3_DCR 
PAPI_L1_DCW = _PAPI_L1_DCW 
PAPI_L2_DCW = _PAPI_L2_DCW 
PAPI_L3_DCW = _PAPI_L3_DCW 
PAPI_L1_ICH = _PAPI_L1_ICH 
PAPI_L2_ICH = _PAPI_L2_ICH 
PAPI_L3_ICH = _PAPI_L3_ICH 
PAPI_L1_ICA = _PAPI_L1_ICA 
PAPI_L2_ICA = _PAPI_L2_ICA 
PAPI_L3_ICA = _PAPI_L3_ICA 
PAPI_L1_ICR = _PAPI_L1_ICR 
PAPI_L2_ICR = _PAPI_L2_ICR 
PAPI_L3_ICR = _PAPI_L3_ICR 
PAPI_L1_ICW = _PAPI_L1_ICW 
PAPI_L2_ICW = _PAPI_L2_ICW 
PAPI_L3_ICW = _PAPI_L3_ICW 
PAPI_L1_TCH = _PAPI_L1_TCH 
PAPI_L2_TCH = _PAPI_L2_TCH 
PAPI_L3_TCH = _PAPI_L3_TCH 
PAPI_L1_TCA = _PAPI_L1_TCA 
PAPI_L2_TCA = _PAPI_L2_TCA 
PAPI_L3_TCA = _PAPI_L3_TCA 
PAPI_L1_TCR = _PAPI_L1_TCR 
PAPI_L2_TCR = _PAPI_L2_TCR 
PAPI_L3_TCR = _PAPI_L3_TCR 
PAPI_L1_TCW = _PAPI_L1_TCW 
PAPI_L2_TCW = _PAPI_L2_TCW 
PAPI_L3_TCW = _PAPI_L3_TCW 
PAPI_FML_INS = _PAPI_FML_INS
PAPI_FAD_INS = _PAPI_FAD_INS
PAPI_FDV_INS = _PAPI_FDV_INS
PAPI_FSQ_INS = _PAPI_FSQ_INS
PAPI_FNV_INS = _PAPI_FNV_INS
PAPI_FP_OPS = _PAPI_FP_OPS 
PAPI_SP_OPS = _PAPI_SP_OPS 
PAPI_DP_OPS = _PAPI_DP_OPS 
PAPI_VEC_SP = _PAPI_VEC_SP 
PAPI_VEC_DP = _PAPI_VEC_DP 
PAPI_REF_CYC = _PAPI_REF_CYC

PAPI_MAX_INFO_TERMS = _PAPI_MAX_INFO_TERMS
PAPI_PMU_MAX = _PAPI_PMU_MAX

# importing values for 'modifier' parameter for cyPAPI_enum_event
PAPI_ENUM_FIRST = _PAPI_ENUM_FIRST
PAPI_ENUM_EVENTS = _PAPI_ENUM_EVENTS
PAPI_ENUM_ALL = _PAPI_ENUM_ALL
PAPI_PRESET_ENUM_AVAIL = _PAPI_PRESET_ENUM_AVAIL
PAPI_NTV_ENUM_UMASKS = _PAPI_NTV_ENUM_UMASKS
PAPI_NTV_ENUM_UMASK_COMBOS = _PAPI_NTV_ENUM_UMASK_COMBOS

# importing native mask and preset mask
PAPI_PRESET_MASK = _PAPI_PRESET_MASK
PAPI_NATIVE_MASK = _PAPI_NATIVE_MASK

def cyPAPI_library_init(version):
    """Initialize cyPAPI library with linked PAPI build.

    Parameters
    __________
    version : int
        Value of PAPI_VER_CURRENT.
    """
    cdef int retval
    # check correct version is provided
    if version != _PAPI_VER_CURRENT:
        raise ValueError('Argument version only takes PAPI_VER_CURRENT.')
    # check PAPI initialization was successful
    retval = PAPI_library_init(version)
    if retval != _PAPI_VER_CURRENT:
        raise _exceptions_for_cypapi[retval]
    return retval

def cyPAPI_is_initialized():
    return PAPI_is_initialized()

def cyPAPI_shutdown():
    PAPI_shutdown()

def cyPAPI_strerror(int error_code):
    cdef char *c_str = PAPI_strerror(error_code)
    if not c_str:
        raise ValueError('Failed to get error message.')
    return str(c_str, encoding='utf-8')

def cyPAPI_num_components():
    cdef int num_comp = PAPI_num_components()
    return num_comp

def cyPAPI_get_component_index(str name):
    cdef int retval = PAPI_get_component_index(name.encode('utf-8'))
    if retval < 0:
        raise _exceptions_for_cypapi[retval]
    return retval

def cyPAPI_get_real_cyc():
    cdef long long time = PAPI_get_real_cyc()
    return time

def cyPAPI_get_real_nsec():
    cdef long long time = PAPI_get_real_nsec()
    return time

def cyPAPI_get_real_usec():
    cdef long long time = PAPI_get_real_usec()
    return time

def cyPAPI_get_virt_cyc():
    cdef long long time = PAPI_get_virt_cyc()
    return time

def cyPAPI_get_virt_nsec():
    cdef long long time = PAPI_get_virt_nsec()
    return time

def cyPAPI_get_virt_usec():
    cdef long long time = PAPI_get_virt_usec()
    return time

def cyPAPI_enum_event(EventCode, modifier):
    """Enumerate PAPI preset or native events.
    
    Parameters
    __________
    EventCode : int
        A defined preset or native event such as PAPI_TOT_INS.
    modifier : int
        Modifies the search logic. Options to use include: PAPI_ENUM_FIRST,
        PAPI_ENUM_EVENTS, PAPI_ENUM_ALL, PAPI_NTV_ENUM_UMASKS,
        PAPI_NTV_ENUM_UMASK_COMBOS, and PAPI_PRESET_ENUM_AVAIL.

    Returns
    _______
    dict
        A dictionary containing the event names as keys and the event codes in 
        hex as values.
    int
        An event code.
    """
    cdef int papi_errno = PAPI_OK
    cdef int evt_code = np.array(EventCode).astype(np.intc)
    cdef int mod = np.array(modifier).astype(np.intc)
    hexcode = 0xffffffff
    events = {}

    # check if a valid modifier has been provided
    valid_modifiers = [ _PAPI_ENUM_FIRST, _PAPI_ENUM_EVENTS, _PAPI_ENUM_ALL,
                        _PAPI_PRESET_ENUM_AVAIL, _PAPI_NTV_ENUM_UMASKS,
                        _PAPI_NTV_ENUM_UMASK_COMBOS]
    if modifier not in valid_modifiers:
        raise ValueError( 'Modifier value not supported. Run '
                          'help(cyPAPI_enum_event) to see available modifiers.')

    # case if PAPI_ENUM_FIRST modifier provided
    if mod == _PAPI_ENUM_FIRST:
        papi_errno = PAPI_enum_event(&evt_code, mod)
        if papi_errno != PAPI_OK:
            raise _exceptions_for_cypapi[papi_errno]
        evt_name = cyPAPI_event_code_to_name(evt_code)
        events[evt_name] = hex(evt_code & hexcode)
    # case if modifier other than PAPI_ENUM_FIRST_PROVIDED
    else:
        while True:
            papi_errno = PAPI_enum_event(&evt_code, mod)
             # add enumerated events to dictionary
            if papi_errno == PAPI_OK: 
                evt_name = cyPAPI_event_code_to_name(evt_code) 
                events[evt_name] = hex(evt_code & hexcode) 
            # completed enumeration of events
            elif papi_errno == PAPI_EINVAL or papi_errno == PAPI_ENOEVNT: 
                break
            # call to PAPI_enum_event failed
            else:
                raise _exceptions_for_cypapi[papi_errno]

    return events, evt_code

cdef void _PAPI_enum_cmp_event(int *EventCode, int modifier, int cidx) except *:
    cdef int retval = PAPI_enum_cmp_event(EventCode, modifier, cidx)
    if retval == PAPI_ENOCMP:
        raise _exceptions_for_cypapi[retval]
    if retval == PAPI_ENOEVNT or retval == PAPI_EINVAL:
        raise StopIteration

cdef class CypapiEnumCmpEvent:
    cdef int ntv_code
    cdef int cidx
    cdef int modifier

    def __cinit__(self, int cidx):
        self.cidx = cidx
        self.modifier = PAPI_ENUM_FIRST
        self.ntv_code = 0 | _PAPI_NATIVE_MASK
    
    def next_event(self):
        if self.modifier == PAPI_ENUM_FIRST:
            _PAPI_enum_cmp_event(&self.ntv_code, PAPI_ENUM_FIRST, self.cidx)
            self.modifier = PAPI_ENUM_EVENTS
            return self.ntv_code
        _PAPI_enum_cmp_event(&self.ntv_code, PAPI_ENUM_EVENTS, self.cidx)
        return self.ntv_code

    def __iter__(self):
        return self

    def __next__(self):
        return self.next_event()

def cyPAPI_query_event(event_code):
    cdef int retval, evt_code = np.array(event_code).astype(np.intc)
    retval = PAPI_query_event(evt_code)

    return retval

def cyPAPI_query_named_event(event_name):
    cdef int retval
    cdef bytes evt_name = event_name.encode('utf8')
    retval = PAPI_query_named_event(evt_name)

    return retval

def cyPAPI_num_cmp_hwctrs(int cidx):
    cdef int retval = PAPI_num_cmp_hwctrs(cidx)
    if retval < 0:
        raise _exceptions_for_cypapi[retval]
    return retval

def cyPAPI_event_code_to_name(event_code):
    # convert Python integer to Numpy value, which follows C overflow logic
    cdef int papi_errno, evt_code = np.array(event_code).astype(np.intc)
    cdef char out[1024]
    papi_errno = PAPI_event_code_to_name(evt_code, out)
    if papi_errno != PAPI_OK:
        raise _exceptions_for_cypapi[papi_errno]
    event_name = str(out, encoding='utf-8')
    return event_name

def cyPAPI_event_name_to_code(str eventname):
    cdef bytes c_name = eventname.encode('utf-8')
    cdef int out = -1
    cdef int papi_errno = PAPI_event_name_to_code(c_name, &out)
    if papi_errno != PAPI_OK:
        raise _exceptions_for_cypapi[papi_errno]
    return out

@dataclass
class CypapiGetComponentInfo:
    """Get information about a specific software component.

    Arguments
    _________
    init_cmp_code : int
        Software component index, required for instantiation.

        Attributes
    __________
    name : str
        Name of software component.
    short_name : str
        Short name of software component.
    description : str
        Description of software component.
    version : str
        Version of software component.
    support_version : str
        Version of support library.
    kernel_version : str
        Version of kernel PMC support driver.
    disabled_reason : str
        Reason for failure of initialization.
    disabled : int
        0 if enabled, otherwise error code from initialization.
    initialized : int
        Software component is ready to use.
    CmpIdx : int
        Index into the vector array for this software component; set at init.
    num_cntrs : int
        Number of hardware counters the software component supports.
    num_mpx_cntrs : int
        Number of hardware counters the component or PAPI can multiplex.
    num_preset_events : int
        Number of preset events the component supports.
    num_native_events : int
        Number of native events the component supports.
    default_domain : int
        Default domain when this software component is used.
    available_domains : int
        Available domains.
    default_granularity : int
        Default granularity when this software component is used.
    available_granularities : int
        Available granularities.
    hardware_intr_sig : int
        Signal used by hardware to deliver PMC events.
    component_type : int
        Type of software component.
    pmu_names : list
        List of pmu names supported by this software component.
    reserved : int
    hardware_intr : int
        HW overflow instructions.
    precise_intr : int
        Performance interrupts happen precisely.
    posix1b_timers : int
        Using POSIX 1b internal timers instead of setitimer.
    kernel_profile : int
        Has kernel profiling support (buffered interrupts or sprofil-like).
    kernel_multiplex : int
        In kernel multiplexing.
    fast_counter_read : int
        Supports a user level PMC read instruction.
    fast_real_timer : int
        Supports a fast real timer.
    fast_virtual_timer : int
        Supports a fast virtual timer.
    attach : int
        Supports attach.
    attach_must_ptrace : int
        Attach must first ptrace and stop the thread/process.
    cntr_umasks : int
        Counters have unit masks.
    cpu : int
        Supports specifying cpu number to use with event set.
    inherit : int
        Supports child processes inheriting parents counters.
    reserved_bits : int
        Reserved bits.
    """
    # required during instantiation
    init_cmp_cidx: InitVar[int]
    # attributes to be assigned post init
    name: str = field( init = False )
    short_name: str = field( init = False )
    description: str = field( init = False )
    version: str = field( init = False )
    support_version: str = field( init = False )
    kernel_version: str = field( init = False )
    disabled_reason: str = field( init = False )
    disabled: int = field( init = False)
    initialized: int = field( init = False )
    CmpIdx: int = field( init = False )
    num_cntrs: int = field( init = False )
    num_mpx_cntrs: int = field( init = False )
    num_preset_events: int = field( init = False )
    num_native_events: int = field( init = False )
    default_domain: int = field( init = False )
    available_domains: int = field( init = False )
    default_granularity: int = field( init = False )
    available_granularities: int = field( init = False )
    hardware_intr_sig: int = field( init = False )
    component_type: int = field( init = False )
    pmu_names: list = field( init = False )
    reserved: list = field( init = False )
    hardware_intr: int = field( init = False )
    precise_intr: int = field( init = False )
    posix1b_timers: int = field( init = False )
    kernel_profile: int = field( init = False )
    kernel_multiplex: int = field( init = False )
    fast_counter_read: int = field( init = False )
    fast_real_timer: int = field( init = False )
    fast_virtual_timer: int = field( init = False )
    attach: int = field( init = False )
    attach_must_ptrace: int = field( init = False )
    cntr_umasks: int = field( init = False )
    cpu: int = field( init = False )
    inherit: int = field( init = False )
    reserved_bits: int = field( init = False )

    # process PAPI_component_info_t structure
    def __post_init__(self, init_cmp_cidx):
        """Initialize attributes depending on PAPI_get_component_info call."""
        valid_pmu_names = []
        cdef const PAPI_component_info_t *cmp_info = NULL
        cmp_info = PAPI_get_component_info(init_cmp_cidx)
        if not cmp_info:
            raise ValueError('Failed to get component info.')

        # parse pmu_names to avoid seg fault from NULL entries
        for idx in range(0, _PAPI_PMU_MAX):
            if cmp_info.pmu_names[idx] == NULL:
                continue
            valid_pmu_names.append( str(cmp_info.pmu_names[idx],
                                    encoding = 'utf-8') )

        # assign post_init attributes
        self.name = str(cmp_info.name, encoding = 'utf-8')
        self.short_name = str(cmp_info.short_name, encoding = 'utf-8')
        self.description = str(cmp_info.description, encoding = 'utf-8')
        self.version = str(cmp_info.version, encoding = 'utf-8')
        self.support_version = str(cmp_info.support_version, encoding = 'utf-8')
        self.kernel_version = str(cmp_info.kernel_version, encoding = 'utf-8')
        self.disabled_reason = str(cmp_info.disabled_reason, encoding = 'utf-8')
        self.disabled = cmp_info.disabled
        self.initialized = cmp_info.initialized
        self.CmpIdx = cmp_info.CmpIdx
        self.num_cntrs = cmp_info.num_cntrs
        self.num_mpx_cntrs = cmp_info.num_mpx_cntrs
        self.num_preset_events = cmp_info.num_preset_events
        self.num_native_events = cmp_info.num_native_events
        self.default_domain = cmp_info.default_domain
        self.available_domains = cmp_info.available_domains
        self.default_granularity = cmp_info.default_granularity
        self.available_granularities = cmp_info.available_granularities
        self.hardware_intr_sig = cmp_info.hardware_intr_sig
        self.component_type = cmp_info.component_type
        self.pmu_names = valid_pmu_names
        self.reserved = [cmp_info.reserved[idx] for idx in range(0, 8)]
        self.hardware_intr = cmp_info.hardware_intr
        self.precise_intr = cmp_info.precise_intr
        self.posix1b_timers = cmp_info.posix1b_timers
        self.kernel_profile = cmp_info.kernel_profile
        self.kernel_multiplex = cmp_info.kernel_multiplex
        self.fast_counter_read = cmp_info.fast_counter_read
        self.fast_real_timer = cmp_info.fast_real_timer
        self.fast_virtual_timer = cmp_info.fast_virtual_timer
        self.attach = cmp_info.attach
        self.attach_must_ptrace = cmp_info.attach_must_ptrace
        self.cntr_umasks = cmp_info.cntr_umasks
        self.cpu = cmp_info.cpu
        self.inherit = cmp_info.inherit
        self.reserved_bits = cmp_info.reserved_bits

@dataclass
class CypapiGetEventInfo:
    """Collects descriptive strings and values for the user specified event.

    Arguments
    _________
    init_evt_code : int
        Event code, required for instantiation.

    Attributes
    __________
    event_code : int
        Event code, either preset or native.
    symbol : str
        Name of the event.
    short_descr : str
        A short description suitable for use as a label.
    long_descr : str
        A longer description typically a sentence or a paragraph.
    comonent_index : int
        Component this event belongs to.
    units : str
        Units event is measured in.
    location : int
        Location event applies to.
    data_type : int
        Data type returned by PAPI.
    value_type : int
        Sum or absolute.
    timescope : int
        From start, etc.
    update_type : int
        How event is updated.
    update_freq : int
        How frequently event is updated.
    count : int
        Number of terms in the code and name fields.
    event_type : int
        Event type or category for preset events only.
    derived : str
        Name of the derived type.
    postfix : str
        String containing postfix operations.
    code : list
        Array of values that further describe the event.
    name : list
        Names of code terms.
    note : str
        Optional developer note.
    """
    # required during instantiation
    init_evt_code: InitVar[int]
    # attributes to be assigned post init
    event_code: int = field( init = False )
    symbol: str = field( init = False )
    short_descr: str = field( init = False )
    long_descr: str = field( init = False )
    component_index: int = field( init = False )
    units: str = field( init = False )
    location: int = field( init = False )
    data_type: int = field( init = False )
    value_type: int = field( init = False )
    timescope: int = field( init = False )
    update_type: int = field( init = False )
    update_freq: int = field( init = False )
    count: int = field( init = False )
    event_type: int = field( init = False )
    derived: str = field( init = False )
    postfix: str = field( init = False )
    code: list = field( init = False )
    name: list = field( init = False )
    note: str = field( init = False )

    # process PAPI_event_info_t structure
    def __post_init__(self, init_evt_code):
        """Initialize attributes depending on PAPI_get_event_info call."""
        cdef PAPI_event_info_t info
        cdef int papi_errno, evt_code = np.array(init_evt_code).astype(np.intc)

        papi_errno = PAPI_get_event_info(evt_code, &info)
        if papi_errno != PAPI_OK:
            raise _exceptions_for_cypapi[papi_errno]

        # assign post init attributes
        self.event_code = info.event_code
        self.symbol = str(info.symbol, encoding = 'utf-8')
        self.short_descr = str(info.short_descr, encoding = 'utf-8')
        self.long_descr = str(info.long_descr, encoding = 'utf-8')
        self.component_index = info.component_index
        self.units = str(info.units, encoding = 'utf-8')
        self.location = info.location
        self.data_type = info.data_type
        self.value_type = info.value_type
        self.timescope = info.timescope
        self.update_type = info.update_type
        self.update_freq = info.update_freq
        self.count = info.count
        self.event_type = info.event_type
        self.derived = str(info.derived, encoding = 'utf-8')
        self.postfix = str(info.postfix, encoding = 'utf-8')
        self.code = [ info.code[idx] for idx in range(0, _PAPI_MAX_INFO_TERMS) ]
        self.name = [ str(info.name[idx], encoding = 'utf-8')
                      for idx in range(0, _PAPI_MAX_INFO_TERMS) ]
        self.note = str(info.note, encoding = 'utf-8')

cdef class CypapiCreateEventset:
    cdef int event_set

    def __cinit__(self):
        self.event_set = PAPI_NULL
        cdef int papi_errno = PAPI_create_eventset(&self.event_set)
        if papi_errno != PAPI_OK:
            raise _exceptions_for_cypapi[papi_errno]

    def __str__(self):
        return f'{self.event_set}'

    def cleanup_eventset(self):
        cdef int papi_errno = PAPI_cleanup_eventset(self.event_set)
        if papi_errno != PAPI_OK:
            raise _exceptions_for_cypapi[papi_errno]

    def destroy_eventset(self):
        cdef int papi_errno = PAPI_destroy_eventset(&self.event_set)
        if papi_errno != PAPI_OK:
            raise _exceptions_for_cypapi[papi_errno]

    def num_events(self):
        cdef int retval = PAPI_num_events(self.event_set)
        if retval < 0:
            raise _exceptions_for_cypapi[retval]
        return retval

    def assign_eventset_component(self, int cidx):
        cdef int papi_errno = PAPI_assign_eventset_component(self.event_set, cidx)
        if papi_errno != PAPI_OK:
            raise _exceptions_for_cypapi[papi_errno]

    def reset(self):
        cdef int papi_errno = PAPI_reset(self.event_set)
        if papi_errno != PAPI_OK:
            raise _exceptions_for_cypapi[papi_errno]

    def add_event(self, event_code):
        # convert Python integer to Numpy value, which follows C overflow logic
        cdef int papi_errno, evt_code = np.array(event_code).astype(np.intc)
        papi_errno = PAPI_add_event(self.event_set, evt_code)
        if papi_errno != PAPI_OK:
            raise _exceptions_for_cypapi[papi_errno]

    def add_named_event(self, str name):
        cdef bytes c_name = name.encode('utf-8')
        cdef int papi_errno = PAPI_add_named_event(self.event_set, c_name)
        if papi_errno != PAPI_OK:
            raise _exceptions_for_cypapi[papi_errno]

    def start(self):
        cdef int papi_errno = PAPI_start(self.event_set)
        if papi_errno != PAPI_OK:
            raise _exceptions_for_cypapi[papi_errno]

    def stop(self):
        cdef int num_events = self.num_events()
        cdef long long *values = <long long *> PyMem_Malloc(num_events * sizeof(long long))
        if not values:
            raise MemoryError('Failed to allocate memory for array.')
        cdef int papi_errno = PAPI_stop(self.event_set, values)
        if papi_errno != PAPI_OK:
            PyMem_Free(values)
            raise _exceptions_for_cypapi[papi_errno]
        result = [values[i] for i in range(num_events)]
        PyMem_Free(values)
        return result

    def read(self):
        cdef int num_events = self.num_events()
        cdef long long *values = <long long *> PyMem_Malloc(num_events * sizeof(long long))
        if not values:
            raise MemoryError('Failed to allocate memory for array.')
        cdef int papi_errno = PAPI_read(self.event_set, values)
        if papi_errno != PAPI_OK:
            raise _exceptions_for_cypapi[papi_errno]
        result = [values[i] for i in range(num_events)]
        PyMem_Free(values)
        return result

    def read_ts(self):
        cdef int num_events = self.num_events()
        cdef long long *values = <long long *> PyMem_Malloc(num_events * sizeof(long long))
        if not values:
            raise MemoryError('Failed to allocate memory for array.')
        cdef long long cyc = -1
        cdef int papi_errno = PAPI_read_ts(self.event_set, values, &cyc)
        if papi_errno != PAPI_OK:
            raise _exceptions_for_cypapi[papi_errno]
        result = [values[i] for i in range(num_events)]
        PyMem_Free(values)
        return result, cyc

    def accum(self, list values):
        cdef int num_events = self.num_events()
        if num_events != len(values):
            raise ValueError('Provided list must have the same length as the'
                             ' number of events in the event set.')
        cdef long long * vals = <long long*> PyMem_Malloc(num_events * sizeof(long long))
        if not vals:
            raise MemoryError('Failed to allocate memory for array.')
        cdef int i
        for i in range(num_events):
            vals[i] = values[i]
        cdef int papi_errno = PAPI_accum(self.event_set, vals)
        if papi_errno != PAPI_OK:
            PyMem_Free(vals)
            raise _exceptions_for_cypapi[papi_errno]
        for i in range(num_events):
            values[i] = vals[i]
        PyMem_Free(vals)

    def list_events(self, probe = False):
        cdef int *evts, papi_errno, num_events = self.num_events()
        # does not probe EventSet
        if not probe:
            evts = <int *> PyMem_Malloc(num_events * sizeof(int))
            if not evts:
                raise MemoryError('Failed to allocate memory for array.')

            papi_errno = PAPI_list_events( self.event_set, evts, &num_events  )
            if papi_errno != PAPI_OK:
                raise _exceptions_for_cypapi[papi_errno]

            result = [evts[i] for i in range(num_events)]
            PyMem_Free(evts)
        # probe EventSet
        else:
            result = num_events
        return result

    def state(self):
        cdef int val = -1
        cdef int papi_errno = PAPI_state(self.event_set, &val)
        if papi_errno != PAPI_OK:
            raise _exceptions_for_cypapi[papi_errno]
        return val

    def write(self, list values):
        cdef int num_events = self.num_events()
        if len(values) > num_events:
            raise ValueError('Provided list must have the same length as the'
                             ' number of events in the event set.')
        cdef long long *vals = <long long *> PyMem_Malloc(len(values))
        if not vals:
            raise MemoryError('Failed to allocate memory for array.')
        cdef int i
        for i in range(len(values)):
            vals[i] = values[i]
        cdef int papi_errno = PAPI_write(self.event_set, vals)
        PyMem_Free(vals)
        if papi_errno != PAPI_OK:
            raise _exceptions_for_cypapi[papi_errno]

    def get_eventset_component(self):
        cdef int retval = PAPI_get_eventset_component(self.event_set)
        if retval < 0:
            raise _exceptions_for_cypapi[retval]
        return retval
