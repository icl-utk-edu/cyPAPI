#!/usr/bin/env python3

# import necessary functions
from cypapi import *
from do_loops import do_flops

# initialize cyPAPI library
cyPAPI_library_init()

# check to make sure cyPAPI has been intialized
if cyPAPI_is_initialized() != 1:
    raise ValueError("cyPAPI has not been initialized.\n")

# test virt time in clock cycles
try:
    vt_cc_start = cyPAPI_get_virt_cyc()
    do_flops()
    vt_cc_stop = cyPAPI_get_virt_cyc()
except:
    raise ValueError("Failed collecting virt time in clock cycles.")

# test virt time in nanoseconds
try:
    vt_ns_start = cyPAPI_get_virt_nsec()
    do_flops()
    vt_ns_stop = cyPAPI_get_virt_nsec()
except:
    raise ValueError("Failed collecting virt time in nanoseconds.")

# test virt time in microseconds
try:
    vt_ms_start = cyPAPI_get_virt_usec()
    do_flops()
    vt_ms_stop = cyPAPI_get_virt_usec()
except: 
    raise ValueError("Failed collecting virt time in microseconds.")

# output if real time cyPAPI functions succeeded
print("Virt time in clock cycles: ", vt_cc_stop - vt_cc_start)
print("Virt time in nanoseconds: ", vt_ns_stop - vt_ns_start)
print("Virt time in microseconds: ", vt_ms_stop - vt_ms_start)
print("\033[0;32mPASSED\033[0m");
