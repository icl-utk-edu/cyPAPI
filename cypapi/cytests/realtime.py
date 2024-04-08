#!/usr/bin/env python3

# import necessary functions
from cypapi import *
from do_loops import do_flops

perrno = PAPI_Error["PAPI_OK"]

# initialize cyPAPI library
cyPAPI_library_init()

# check to make sure cyPAPI has been intialized
if cyPAPI_is_initialized() != 1:
    raise ValueError("cyPAPI has not been initialized.\n")

# test real time cyPAPI functions
try: 
    # real time in clock cycles
    rt_cc_start = cyPAPI_get_real_cyc()
    do_flops()
    rt_cc_stop = cyPAPI_get_real_cyc()
    # real time in nanoseconds
    rt_ns_start = cyPAPI_get_real_nsec()
    do_flops()
    rt_ns_stop = cyPAPI_get_real_nsec()
    # real time in microseconds
    rt_ms_start = cyPAPI_get_real_usec()
    do_flops()
    rt_ms_stop = cyPAPI_get_real_usec()
# handle error
except:
    perrno = PAPI_Error["PAPI_EINVAL"]

# output if real time cyPAPI functions succeeded
if perrno == PAPI_Error["PAPI_OK"]:
    print("Real time in clock cycles: ", rt_cc_stop - rt_cc_start)
    print("Real time in nanoseconds: ", rt_ns_stop - rt_ns_start)
    print("Real time in microseconds: ", rt_ms_stop - rt_ms_start)
    print("\033[0;32mPASSED\033[0m");
# output if real time cyPAPI functions failed
else:
    print("\033[0;31mFAILED\033[0m");
