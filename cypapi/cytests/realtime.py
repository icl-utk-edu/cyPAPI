#!/usr/bin/env python3

# import necessary functions
from cypapi import *
from do_loops import do_flops

# initialize cyPAPI library
cyPAPI_library_init()

# check to make sure cyPAPI has been intialized
if cyPAPI_is_initialized() != 1:
    raise ValueError("cyPAPI has not been initialized.\n")

# test real time in clock cycles
try:
    rt_cc_start = cyPAPI_get_real_cyc()
    do_flops()
    rt_cc_stop = cyPAPI_get_real_cyc()
except:
    raise ValueError("Failed collecting real time in clock cycles.")

# test real time in nanoseconds
try:
    rt_ns_start = cyPAPI_get_real_nsec()
    do_flops()
    rt_ns_stop = cyPAPI_get_real_nsec()
except:
    raise ValueError("Failed collecting real time in nanoseconds.")

# test real time in microseconds
try:
    rt_ms_start = cyPAPI_get_real_usec()
    do_flops()
    rt_ms_stop = cyPAPI_get_real_usec()
except: 
    raise ValueError("Failed collecting real time in microseconds.")


# output if real time cyPAPI functions succeeded
print("Real time in clock cycles: ", rt_cc_stop - rt_cc_start)
print("Real time in nanoseconds: ", rt_ns_stop - rt_ns_start)
print("Real time in microseconds: ", rt_ms_stop - rt_ms_start)
print("\033[0;32mPASSED\033[0m");
