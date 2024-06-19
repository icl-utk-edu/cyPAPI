#!/usr/bin/env python3

# importing necessary functions
from cypapi import *

# initialize cyPAPI library
cyPAPI_library_init()

# check to make sure cyPAPI has been intialized
if cyPAPI_is_initialized() != 1:
    raise ValueError("cyPAPI has not been initialized.\n")

# test converting PAPI preset define to event name
try:
    define = PAPI_TOT_INS
    evt_def_name = cyPAPI_event_code_to_name(define)
except:
    raise ValueError("Failed converting PAPI define to event name.")

# test converting PAPI preset hexadecimal to event name
try:
    hex_code = 0x80000066
    evt_hex_name = cyPAPI_event_code_to_name(hex_code)
except:
    raise ValueError("Failed converting hexadecimal to event name.")

# test converting PAPI preset decimal to event name 
try:
    decimal_code = -2147483632
    evt_dec_name = cyPAPI_event_code_to_name(decimal_code)
except:
    raise ValueError("Failed converting decimal to event name.")

# test converting native event code to event name
try: 
    enum_ntv = CyPAPI_enum_component_events(0)
    ntv_code = enum_ntv.next_event()
    evt_ntv_name = cyPAPI_event_code_to_name(ntv_code)
except:
    raise ValueError("Failed converting native event code to event name.")

# output if all cyPAPI conversions were successful
print("Eventname for PAPI define: ", evt_def_name)
print("Eventname for hexadecimal: ", evt_hex_name)
print("Eventname for decimal: ", evt_dec_name)
print("Eventname for native event code: ", evt_ntv_name)
print("\033[0;32mPASSED\033[0m")
