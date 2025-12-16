# cython: language_level=3str
from cpython.mem cimport PyMem_Malloc, PyMem_Realloc, PyMem_Free
from dataclasses import dataclass, field, InitVar
from collections.abc import Iterator
from typing import Union, Callable

import numpy as np
import cython

cimport numpy as np
cimport posix.dlfcn as dlfcn

from cypapi.cypapi_exceptions import _exceptions_for_cypapi
from cypapi.papi cimport *
from cypapi.papiStdEventDefs cimport *
if CUDA_COMPILED_IN:
    from cypapi.papiCudaStdEventDefs cimport *

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

# importing Cuda GPU preset defines to be used in cyPAPI
if CUDA_COMPILED_IN:
    PAPI_CUDA_FP16_FMA = _PAPI_CUDA_FP16_FMA
    PAPI_CUDA_BF16_FMA = _PAPI_CUDA_BF16_FMA
    PAPI_CUDA_FP32_FMA = _PAPI_CUDA_FP32_FMA
    PAPI_CUDA_FP64_FMA = _PAPI_CUDA_FP64_FMA
    PAPI_CUDA_FP_FMA   = _PAPI_CUDA_FP_FMA
    PAPI_CUDA_FP8_OPS  = _PAPI_CUDA_FP8_OPS

# importing native mask and preset mask
PAPI_PRESET_MASK = _PAPI_PRESET_MASK
PAPI_NATIVE_MASK = _PAPI_NATIVE_MASK

# importing values for 'modifier' parameter for cyPAPI_enum_event
PAPI_ENUM_FIRST = _PAPI_ENUM_FIRST
PAPI_ENUM_EVENTS = _PAPI_ENUM_EVENTS
PAPI_ENUM_ALL = _PAPI_ENUM_ALL
PAPI_PRESET_ENUM_AVAIL = _PAPI_PRESET_ENUM_AVAIL
PAPI_PRESET_ENUM_FIRST_COMP = _PAPI_PRESET_ENUM_FIRST_COMP
PAPI_PRESET_ENUM_CPU = _PAPI_PRESET_ENUM_CPU
PAPI_PRESET_ENUM_CPU_AVAIL = _PAPI_PRESET_ENUM_CPU_AVAIL
PAPI_NTV_ENUM_UMASKS = _PAPI_NTV_ENUM_UMASKS
PAPI_NTV_ENUM_UMASK_COMBOS = _PAPI_NTV_ENUM_UMASK_COMBOS

# importing array lengths
PAPI_MAX_INFO_TERMS = _PAPI_MAX_INFO_TERMS
PAPI_PMU_MAX = _PAPI_PMU_MAX

def cyPAPI_library_init(version: int) -> int:
    """Initialize the cyPAPI library with a linked PAPI build.

    :param version: Value of PAPI_VER_CURRENT
    :type version: int
    :returns: PAPI_VER_CURRENT
    :rtype: int
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

def cyPAPI_is_initialized() -> int:
    """Check if cyPAPI is or is not initialized.

    :returns: Status of the cyPAPI library
    :rtype: int 
    """
    return PAPI_is_initialized()

def cyPAPI_shutdown() -> None:
    """Finish using cyPAPI and free all related resources."""
    PAPI_shutdown()

def cyPAPI_strerror(error_code: int) -> str:
    """Convert an error code to its corresponding error message.

    :param error_code: A PAPI error code
    :type error_code: int
    :returns: An error messsage corresponding to the provided error code
    :rtype: str
    """
    cdef char *c_str = PAPI_strerror(error_code)
    if not c_str:
        raise ValueError('Failed to get error message.')

    return str(c_str, encoding='utf-8')

def cyPAPI_num_components() -> int:
    """Get the number of components available on the system.

    :returns: The number of components available on the system.
    :rtype: int
    """
    cdef int retval = PAPI_num_components()
    if retval < 0:
        _exceptions_for_cypapi[retval]

    return retval 

def cyPAPI_get_component_index(name: str) -> int:
    """Get the component index for the named component.

    :param name:
    :type name: str
    :returns: A component index
    :rtype: int
    """
    cdef int retval = PAPI_get_component_index(name.encode('utf-8'))
    if retval < 0:
        raise _exceptions_for_cypapi[retval]

    return retval

def cyPAPI_get_real_cyc() -> int:
    """Get a real time counter value in clock cycles.
    This call is equivalent to wall clock time.

    :returns: The total real time passed since some arbitrary starting point in clock cycles
    :rtype: int
    """
    cdef long long retval = PAPI_get_real_cyc()
    if retval < 0:
        raise _exceptions_for_cypapi[retval]

    return retval

def cyPAPI_get_real_nsec() -> int:
    """Get a real time counter value in nanoseconds.
    This call is equivalent to wall clock time.

    :returns: The total real time passed since some arbitrary starting point in nanoseconds
    :rtype: int
    """
    cdef long long retval = PAPI_get_real_nsec()
    if retval < 0:
        raise _exceptions_for_cypapi[retval]

    return retval

def cyPAPI_get_real_usec() -> int:
    """Get a real time counter value in microseconds.
    This call is equivalent to wall clock time.

    :returns: The total real time passed since some arbitrary starting point in microseconds
    :rtype: int
    """
    cdef long long retval = PAPI_get_real_usec()
    if retval < 0:
        raise _exceptions_for_cypapi[retval]

    return retval

def cyPAPI_get_virt_cyc() -> int:
    """Get a virtual time counter value in clock cycles.

    :returns: The total number of virtual units from some arbitrary starting point in clock cycles
    :rtype: int
    """
    cdef long long retval = PAPI_get_virt_cyc()
    if retval < 0:
        raise _exceptions_for_cypapi[retval]

    return retval

def cyPAPI_get_virt_nsec() -> int:
    """Get a virtual time counter value in nanoseconds.

    :returns: The total number of virtual units from some arbitrary starting point in nanoseconds
    :rtype: int
    """
    cdef long long retval = PAPI_get_virt_nsec()
    if retval < 0:
        raise _exceptions_for_cypapi[retval]

    return retval

def cyPAPI_get_virt_usec() -> int:
    """Get a virtual time counter value in microseconds.

    :returns: The total number of virtual units from some arbitrary starting point in microseconds
    :rtype: int
    """
    cdef long long retval = PAPI_get_virt_usec()
    if retval < 0:
        raise _exceptions_for_cypapi[retval]

    return retval

def cyPAPI_enum_event(event_code: int, modifier: int) -> tuple[dict[str, str], int]:
    """Enumerate PAPI preset or native events.

    :param event_code: A defined preset or native event such as PAPI_TOT_INS
    :type event_code: int
    :param modifier: Modifies the search logic. Options to use include: PAPI_ENUM_FIRST,
                     PAPI_ENUM_EVENTS, PAPI_ENUM_ALL, PAPI_NTV_ENUM_UMASKS, PAPI_NTV_ENUM_UMASK_COMBOS,
                     and PAPI_PRESET_ENUM_AVAIL.
    :type modifier: int
    :returns: A tuple which contains a dictionary with the event names as keys and the event codes in hex
              as values and a new event code
    :rtype: tuple
    """
    cdef int retval
    cdef int evt_code = np.array(event_code).astype(np.intc)
    cdef int mod = np.array(modifier).astype(np.intc)
    hexcode = 0xffffffff
    events = {}

    # check if a valid modifier has been provided
    valid_modifiers = [ _PAPI_ENUM_FIRST, _PAPI_ENUM_EVENTS, _PAPI_ENUM_ALL,
                        _PAPI_PRESET_ENUM_AVAIL, _PAPI_PRESET_ENUM_CPU,
                        _PAPI_PRESET_ENUM_CPU_AVAIL, _PAPI_PRESET_ENUM_FIRST_COMP,
                        _PAPI_NTV_ENUM_UMASKS, _PAPI_NTV_ENUM_UMASK_COMBOS]
    if modifier not in valid_modifiers:
        raise ValueError( 'Modifier value not supported. Run '
                          'help(cyPAPI_enum_event) to see available modifiers.')

    # case if PAPI_ENUM_FIRST modifier provided
    if mod == _PAPI_ENUM_FIRST or _PAPI_PRESET_ENUM_FIRST_COMP:
        retval = PAPI_enum_event(&evt_code, mod)
        if retval != PAPI_OK:
            raise _exceptions_for_cypapi[retval]
        evt_name = cyPAPI_event_code_to_name(evt_code)
        events[evt_name] = hex(evt_code & hexcode)
    # case if modifier other than PAPI_ENUM_FIRST_PROVIDED
    else:
        while True:
            retval = PAPI_enum_event(&evt_code, mod)
             # add enumerated events to dictionary
            if retval == PAPI_OK: 
                evt_name = cyPAPI_event_code_to_name(evt_code) 
                events[evt_name] = hex(evt_code & hexcode) 
            # completed enumeration of events
            elif retval == PAPI_EINVAL or retval == PAPI_ENOEVNT: 
                break
            # call to PAPI_enum_event failed
            else:
                raise _exceptions_for_cypapi[retval]

    return events, evt_code

cdef void _PAPI_enum_cmp_event(EventCode: cython.p_int, modifier: int, cidx: int) except *:
    """Internal function that calls PAPI_enum_cmp_event.

    :param EventCode: An event code
    :type EventCode: int
    :param modifier: A modifier to change the search logic such as PAPI_ENUM_FIRST
    :type modifier: int
    :param cidx: The component's index
    :type cidx: int
    """
    cdef int retval = PAPI_enum_cmp_event(EventCode, modifier, cidx)
    if retval == PAPI_ENOCMP:
        raise _exceptions_for_cypapi[retval]
    if retval == PAPI_ENOEVNT or retval == PAPI_EINVAL:
        raise StopIteration

cdef class CypapiEnumCmpEvent:
    cdef int ntv_code
    cdef int cidx
    cdef int modifier

    def __cinit__(self, cidx: int) -> None:
        """Initialize a CypapiEnumCmpEvent object.

        :param cidx: Component index to enumerate events for
        :type cidx: int
        """
        self.cidx = cidx
        self.modifier = PAPI_ENUM_FIRST
        self.ntv_code = 0 | _PAPI_NATIVE_MASK
    
    def next_event(self) -> int:
        """Move to the next event.

        :returns: The next event code
        :rtype: int
        """
        if self.modifier == PAPI_ENUM_FIRST:
            _PAPI_enum_cmp_event(&self.ntv_code, PAPI_ENUM_FIRST, self.cidx)
            self.modifier = PAPI_ENUM_EVENTS
            return self.ntv_code
        _PAPI_enum_cmp_event(&self.ntv_code, PAPI_ENUM_EVENTS, self.cidx)
        return self.ntv_code

    def __iter__(self) -> Iterator[int]:
        """Returns the iterator object for CypapiEnumCmpEvent.

        :returns: Iterator object
        :rtype: Iterator[int]
        """
        return self

    def __next__(self) -> int:
        """Iterates the next item in the sequence or raises StopIteration if we have hit the end.

        :returns The next item in the sequence i.e. the next event code
        :rtype: int
        """
        return self.next_event()

def cyPAPI_query_event(event_code: int) -> int:
    """Query if a cyPAPI event code exists.

    :param event_code: A defined event such as PAPI_TOT_INS
    :type event_code: int
    :returns: 0 if the event CAN be counted and a negative number if the event CANNOT be counted
    :rtype: int
    """
    cdef int retval
    cdef int evt_code = np.array(event_code).astype(np.intc)
    retval = PAPI_query_event(evt_code)

    return retval

def cyPAPI_query_named_event(event_name: str) -> int:
    """Query if a named cyPAPI event exists.

    :param event_name: A defined event name such as PAPI_TOT_INS
    :type event_name: str
    :returns: 0 if the event CAN be counted and a negative number if the event CANNOT be counted
    :rtype: int
    """
    cdef int retval
    cdef bytes evt_name = event_name.encode('utf8')
    retval = PAPI_query_named_event(evt_name)

    return retval

def cyPAPI_num_cmp_hwctrs(cidx: int) -> int:
    """Get the number of hardware counters for the specified component.

    :param cidx: An integer identifier for a component
    :type cidx: int
    :returns: The number of hardware counters for the specified component
    :rtype: int 
    """
    cdef int retval = PAPI_num_cmp_hwctrs(cidx)
    if retval < 0:
        raise _exceptions_for_cypapi[retval]
    return retval

def cyPAPI_event_code_to_name(event_code: int) -> str:
    """Convert a numeric hardware event code to a name.

    :param event_code: A numeric hardware event code
    :type event_code: int
    :returns: The event name that corresponds to the provided event code
    :rtype: str
    """
    # convert Python integer to Numpy value, which follows C overflow logic
    cdef int retval, evt_code = np.array(event_code).astype(np.intc)
    cdef char out[1024]
    retval = PAPI_event_code_to_name(evt_code, out)
    if retval != PAPI_OK:
        raise _exceptions_for_cypapi[retval]
    event_name = str(out, encoding='utf-8')
    return event_name

def cyPAPI_event_name_to_code(event_name: str) -> int:
    """Convert an event name to a numeric hardware event code.

    :param event_name: A preset or native event name
    :type event_name: str
    :returns: The event code that corresponds to the provided event name
    :rtype: int
    """
    cdef bytes c_name = event_name.encode('utf-8')
    cdef int out = -1
    cdef int retval = PAPI_event_name_to_code(c_name, &out)
    if retval != PAPI_OK:
        raise _exceptions_for_cypapi[retval]
    return out

cdef object _user_thread_defined_callback = None
cdef unsigned long _convert_user_defined_callback() noexcept:
    """Internal function to convert Python callable to C callable
    for cyPAPI_thread_init.

    :returns: A callback function that returns the current thread id
    :rtype: Callable
    """
    return _user_thread_defined_callback()

def cyPAPI_thread_init(thread_defined_callback: Callable) -> None:
    """Initialize thread support in cyPAPI.

    :param thread_id_callback: A callback function that returns the current thread id
    :type thread_id_callback: Callable
    """
    global _user_thread_defined_callback
    if _user_thread_defined_callback is not None:
        raise RuntimeError("Callback already defined.")
    else:
        _user_thread_defined_callback = thread_defined_callback

    cdef int retval = PAPI_thread_init(_convert_user_defined_callback)
    if retval != PAPI_OK:
        raise _exceptions_for_cypapi[retval]

def cyPAPI_register_thread() -> None:
    """Notify cyPAPI that a thread has 'appeared'."""
    cdef int retval = PAPI_register_thread()
    if retval != PAPI_OK:
        raise _exceptions_for_cypapi[retval]

def cyPAPI_unregister_thread() -> None:
    """Notify cyPAPI that a thread has 'disappeared'."""
    cdef int retval = PAPI_unregister_thread()
    if retval != PAPI_OK:
        raise _exceptions_for_cypapi[retval]

def cyPAPI_thread_id() -> str:
    """Get the thread identifier of the current thread.

    :returns: Current thread id as a hexadecimal.
    :rtype: str
    """
    cdef unsigned long retval = PAPI_thread_id();
    # Convert to an int to check for negative return values
    if <int> retval < 0:
        raise _exceptions_for_cypapi[<int> retval]

    return hex(retval)

def cyPAPI_list_threads() -> tuple(int, list[str]):
    """Get the total number of thread ids and a list of the registered thread ids.

    :returns: A tuple with the total number of thread ids in index 0
              and the list of thread ids in index 1
    :rtype: tuple
    """
    cdef int number_of_threads
    cdef int retval = PAPI_list_threads(NULL, &number_of_threads)
    if retval != PAPI_OK:
        raise _exceptions_for_cypapi[retval]

    cdef PAPI_thread_id_t *array_of_thread_ids = <PAPI_thread_id_t *> PyMem_Malloc(number_of_threads * sizeof(PAPI_thread_id_t))
    if not array_of_thread_ids:
        raise MemoryError("Failed to allocate memory for array_of_thread_ids.")

    retval = PAPI_list_threads(array_of_thread_ids, &number_of_threads)
    if retval != PAPI_OK:
        PyMem_Free(array_of_thread_ids)
        raise _exceptions_for_cypapi[retval]

    try:
        list_of_thread_ids = [hex(array_of_thread_ids[i]) for i in range( 0, number_of_threads )]
    finally:
        PyMem_Free(array_of_thread_ids)

    return number_of_threads, list_of_thread_ids

@dataclass
class CypapiGetComponentInfo:
    """Get information about a specific software component.

    Arguments
    _________
    :param init_cmp_cidx: Software component index to get infromation for
    :type init_cmp_cidx: int

    Attributes
    __________
    :param name: Name of the software component
    :type name: str
    :param short_name: Short name of the software component
    :type short_name: str
    :param description: Description of the software component
    :type description: str
    :param version: Version of the software component
    :type version: str
    :param support_version: Version of the support library
    :type support_version: str
    :param kernel_version: Version of the kernel PMC support driver
    :type kernel_version: str
    :param disabled_reason: Reason for failure of initialization
    :type disabled_reason: str
    :param disabled: 0 if enabled, otherwise error code from initialization
    :type disabled: int
    :param initialized: Software component is ready to use
    :type initialized: int
    :param CmpIdx: Index into the vector array for this software component; set at init
    :type CmpIdx: int
    :param num_cntrs: Number of hardware counters the software component supports
    :type num_cntrs: int
    :param num_mpx_cntrs: Number of hardware counters the component or cyPAPI can multiplex
    :type num_mpx_cntrs: int
    :param num_preset_events: Number of preset events the component supports
    :type num_preset_events: int
    :param num_native_events: Number of native events the component supports
    :type num_native_events: int
    :param default_domain: Default domain when this software component is used
    :type default_domain: int
    :param available_domains: Available domains
    :type available_domains: int
    :param default_granularity: Default granularity when this software component is used
    :type default_granularity: int
    :param available_granularities: Available granularities
    :type available_granularities: int
    :param hardware_intr_sig: Signal used by the hardware to deliver PMC events
    :type hardware_intr_sig: int
    :param component_type: Type of software component
    :type component_type: int
    :param pmu_names: List of pmu names supported by this software component
    :type pmu_names: list
    :param reserved:
    :type reserved: int
    :param hardware_intr: HW overflow instructions
    :type hardware_intr: int
    :param precise_intr: Performance interrupts happen precisely
    :type precise_intr: int
    :param posix1b_timers: Using POSIX 1b internal timers instead of setittimer
    :type posix1b_timers: int
    :param kernel_profile: Has kernel profiling support (buffered interrupts or sprofil-like)
    :type kernel_profile: int
    :param kernel_multiplex: In kernel multiplexing
    :type kernel_multiplex: int
    :param fast_counter_read: Supports a user level PMC read instruction
    :type fast_counter_read: int
    :param fast_real_timer: Supports a fast real timer
    :type fast_real_timer: int
    :param fast_virtual_timer: Supports a fast virtual timer
    :type fast_virtual_timer: int
    :param attach: Supports attach
    :type attach: int
    :param attach_must_ptrace: Attach must first ptrace and stop the thread/process
    :type attach_must_ptrace: int
    :param cntr_umasks: Counters have unit masks
    :type cntr_umasks: int
    :param cpu: Supports specifying the cpu number to use with the EventSet
    :type cpu: int
    :param inherit: Supports child processes inheriting parents counters
    :type inherit: int
    :param reserved_bits: Reserved bits
    :type reserved_bits: int
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
    def __post_init__(self, init_cmp_cidx: int) -> None:
        """Initialize attributes depending on PAPI_get_component_info call.

        :param init_cmp_cidx: Software component index to get infromation for
        :type init_cmp_cidx: int
        """
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
    :param init_evt_code: Event code you want to collect descriptive strings and values for
    :type init_evt_code: int

    Attributes
    __________
    :param event_code: Event code, either preset or native
    :type event_code: int
    :param symbol: Name of the event
    :type symbol: str
    :param short_descr: A short description suitable for use as a label
    :type short_descr: str
    :param long_descr: A longer description typically a sentence or a paragraph
    :type long_descr: str
    :param component_index: Component this event belongs to
    :type component_index: int
    :param units: Units event is measured in
    :type units: str
    :param location: Location event applies to
    :type location: int
    :param data_type: Data type returned by cyPAPI
    :type data_type: int
    :param value_type: Sum or absolute
    :type value_type: int
    :param timescope: From start, etc.
    :type timescope: int
    :param update_type: How event is updated
    :type update_type: int
    :param update_freq: How frequently event is updated
    :type update_freq: int
    :param count: Number of terms in the code and name fields
    :type count: int
    :param event_type: Event type or category for preset events only
    :type event_type: int
    :param derived: Name of the derived type
    :type derived: str
    :param postfix: String containing postfix operations
    :type postfix: str
    :param code: Array of values that further describe the event
    :type code: list
    :param name: Name of code terms
    :type name: list
    :param note: Optional developer note
    :type note: str
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
    def __post_init__(self, init_evt_code: int) -> None:
        """Initialize attributes depending on PAPI_get_event_info call.

        :param init_evt_code: Event code, either preset or native
        :type init_evt_code: int
        """
        cdef PAPI_event_info_t info
        cdef int retval, evt_code = np.array(init_evt_code).astype(np.intc)

        retval = PAPI_get_event_info(evt_code, &info)
        if retval != PAPI_OK:
            raise _exceptions_for_cypapi[retval]

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

    def __cinit__(self) -> None:
        """Initialize a CypapiCreateEventSet object."""
        self.event_set = PAPI_NULL
        cdef int retval = PAPI_create_eventset(&self.event_set)
        if retval != PAPI_OK:
            raise _exceptions_for_cypapi[retval]

    def __str__(self) -> str:
        """Return the string representation of the class.

        :returns: The corresponding EventSet integer
        :rtype: str
        """
        return f"{self.event_set}"

    def cleanup_eventset(self) -> None:
        """Remove all events from an eventset and turn off profiling for all events in the EventSet."""
        cdef int retval = PAPI_cleanup_eventset(self.event_set)
        if retval != PAPI_OK:
            raise _exceptions_for_cypapi[retval]

    def destroy_eventset(self) -> None:
        """Deallocate the memory associated with an empty EventSet."""
        cdef int retval = PAPI_destroy_eventset(&self.event_set)
        if retval != PAPI_OK:
            raise _exceptions_for_cypapi[retval]

    def num_events(self) -> int:
        """Get the number of events contained in an EventSet.

        :returns: Total number of events contained in the EventSet
        :rtype: int
        """
        cdef int retval = PAPI_num_events(self.event_set)
        if retval < 0:
            raise _exceptions_for_cypapi[retval]
        return retval

    def assign_eventset_component(self, cidx: int) -> None:
        """Assign a component index to an existing but empty EventSet.
        By convention the cpu component is always 0.

        :param cidx: The integer index for the component you wish to assign to an empty EventSet
        :type: int
        """
        cdef int retval = PAPI_assign_eventset_component(self.event_set, cidx)
        if retval != PAPI_OK:
            raise _exceptions_for_cypapi[retval]

    def reset(self) -> None:
        """Reset the hardwared event counts in an EventSet."""
        cdef int retval = PAPI_reset(self.event_set)
        if retval != PAPI_OK:
            raise _exceptions_for_cypapi[retval]

    def add_event(self, event_code: int) -> None:
        """Add a preset or native hardware event to an EventSet by code.

        :param event_code: A preset or native hardware event code
        :type event_code: int
        """
        # convert Python integer to Numpy value, which follows C overflow logic
        cdef int retval, evt_code = np.array(event_code).astype(np.intc)
        retval = PAPI_add_event(self.event_set, evt_code)
        if retval != PAPI_OK:
            raise _exceptions_for_cypapi[retval]

    def add_named_event(self, event_name: str) -> None:
        """Add a preset or native hardware event to an EventSet by name.

        :param event_name: A preset or native hardware event name
        :type event_name: str
        """
        cdef bytes c_name = event_name.encode('utf-8')
        cdef int retval = PAPI_add_named_event(self.event_set, c_name)
        if retval != PAPI_OK:
            raise _exceptions_for_cypapi[retval]

    def remove_event(self, event_code: int) -> None:
        """Remove a preset or native hardware event from an EventSet by code.

        :param event_code: A preset or native hardware event code
        :type event_code: int 
        """
        cdef int evt_code = np.array(event_code).astype(np.intc)
        cdef int retval = PAPI_remove_event(self.event_set, evt_code)
        if retval != PAPI_OK:
            raise _exceptions_for_cypapi[retval]

    def remove_named_event(self, event_name: str) -> None:
        """Remove a preset or native hardware event from an EventSet by name.

        :param event_name: A preset or native hardware event name
        :type event_name: str
        """
        cdef bytes c_string_event_name = event_name.encode('utf-8')
        cdef int retval = PAPI_remove_named_event(self.event_set, c_string_event_name)
        if retval != PAPI_OK:
            raise _exceptions_for_cypapi[retval]

    def start(self) -> None:
        """Start counting the hardware events in the EventSet."""
        cdef int retval = PAPI_start(self.event_set)
        if retval != PAPI_OK:
            raise _exceptions_for_cypapi[retval]

    def stop(self) -> list[int]:
        """Stop counting the hardware events in the EventSet.

        :returns: A list of counter value(s) for the hardware event(s) in the EventSet
        :rtype: list
        """
        cdef int retval
         # memory allocation for array to be passed to PAPI function
        cdef long long *counter_vals = <long long *> PyMem_Malloc(
            self.num_events() * sizeof(long long) )
        if not counter_vals:
            raise MemoryError('Failed to allocate memory for array')
        
        # handle PAPI function call
        retval = PAPI_stop(self.event_set, counter_vals)
        if retval != PAPI_OK:
            PyMem_Free(counter_vals)
            raise _exceptions_for_cypapi[retval]

        # try to convert array of counter values to list to be returned
        try:
            return [counter_vals[idx] for idx in range( 0, self.num_events() )]
        # free memory
        finally:
            PyMem_Free(counter_vals)

    def read(self) -> list[int]:
        """Read hardware counters from the EventSet.

        :returns: A list of counter value(s) for the hardware event(s) in the EventSet
        :rtype: list
        """
        cdef int retval
        # memory allocation for array to be passed to PAPI function
        cdef long long *counter_vals = <long long *> PyMem_Malloc(
            self.num_events() * sizeof(long long) )
        if not counter_vals:
            raise MemoryError('Failed to allocate memory for array')
        
        # handle PAPI function call
        retval = PAPI_read(self.event_set, counter_vals)
        if retval != PAPI_OK:
            PyMem_Free(counter_vals)
            raise _exceptions_for_cypapi[retval]
        
        # try to convert array of counter values to list to be returned
        try:
            return [counter_vals[idx] for idx in range( 0, self.num_events() )]
        # free memory
        finally:
            PyMem_Free(counter_vals)

    def read_ts(self) -> tuple[list[int], int]:
        """Read hardware counters from the EventSet with a time stamp.
        
        :returns: A tuple which contains a list of counter value(s) and a time stamp
        :rtype: tuple
        """
        cdef int retval
        cdef long long cycles = -1
        # memory allocation for array to be passed to PAPI function
        cdef long long *counter_vals = <long long *> PyMem_Malloc(
            self.num_events() * sizeof(long long) )
        if not counter_vals:
            raise MemoryError('Failed to allocate memory for array')
        
        # handle PAPI function call
        retval = PAPI_read_ts(self.event_set, counter_vals, &cycles)
        if retval != PAPI_OK:
            PyMem_Free(counter_vals)
            raise _exceptions_for_cypapi[retval]
        
        # try to convert array of counter values to list to be returned
        try:
            return ([counter_vals[idx] for idx in range( 0, self.num_events() )],
                    cycles)
        # free memory
        finally:
            PyMem_Free(counter_vals)

    def accum(self, values: list[int]) -> list[int]:
        """Accumulate and reset counters in the EventSet.

        :param values: A list of counter value(s) for the counting events
        :type values: list
        :returns: A list of counter value(s) for the hardware event(s) in the EventSet
        :rtype: list
        """
        cdef int retval
        # the list values must be initialized for accum
        if self.num_events() != len(values):
            raise ValueError('Provided list must have the same length as the'
                             ' number of events in the event set.')
        # memory allocation for array to be passed to PAPI function
        cdef long long *counter_vals= <long long *> PyMem_Malloc(
            self.num_events() * sizeof(long long) )
        if not counter_vals:
            raise MemoryError('Failed to allocate memory for array')

        # handle PAPI function call
        for i in range(self.num_events()):
            counter_vals[i] = values[i]
        retval = PAPI_accum(self.event_set, counter_vals)
        if retval != PAPI_OK:
            PyMem_Free(counter_vals)
            raise _exceptions_for_cypapi[retval]
        
        # try to convert array of counter values to list to be returned
        try:
            return [counter_vals[idx] for idx in range( 0, self.num_events() )]
        # free memory
        finally:
            PyMem_Free(counter_vals)

    def list_events(self, probe: bool = False) -> Union[list[int], int]:
        """List the events in the EventSet.

        :param probe: Set equal to True to output the total number of events in the EventSet
        :type probe: bool
        :returns: A list of events in the event set or the total number of events in the EventSet
        :rtype: Union[list[int], str]
        """
        cdef int *evts
        cdef int retval, num_events = self.num_events()
        # does not probe EventSet
        if not probe:
            evts = <int *> PyMem_Malloc(num_events * sizeof(int))
            if not evts:
                raise MemoryError('Failed to allocate memory for array.')

            retval = PAPI_list_events( self.event_set, evts, &num_events  )
            if retval != PAPI_OK:
                raise _exceptions_for_cypapi[retval]

            # try to convert array of counter values to list to be returned
            try:
                return [evts[i] for i in range( 0, num_events )]
            # free memory
            finally:
                PyMem_Free(evts)
        # probe EventSet
        else:
            return num_events

    def state(self) -> int:
        """Get the counting state of the EventSet.

        :returns: A numerical value which represents the counting state of an EventSet
        :rtype: int
        """
        cdef int val = -1
        cdef int retval = PAPI_state(self.event_set, &val)
        if retval != PAPI_OK:
            raise _exceptions_for_cypapi[retval]
        return val

    def write(self, values: list[int]) -> None:
        """Write counter values into counters.

        :params values: A list of counter values to write into the EventSet
        :type values: list
        """
        cdef int retval
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
        retval = PAPI_write(self.event_set, vals)
        PyMem_Free(vals)
        if retval != PAPI_OK:
            raise _exceptions_for_cypapi[retval]

    def get_eventset_component(self) -> int:
        """Get the component index an EventSet is assigned to.

        :returns: The index of the component the EventSet is assigned to.
        :rtype: int
        """
        cdef int retval = PAPI_get_eventset_component(self.event_set)
        if retval < 0:
            raise _exceptions_for_cypapi[retval]
        return retval
