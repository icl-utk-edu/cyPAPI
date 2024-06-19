#!/usr/bin/env python3

# importing necessary functions
from cypapi import *

# initialize cyPAPI library
cyPAPI_library_init()

# check to make sure cyPAPI has been intialized
if cyPAPI_is_initialized() != 1:
    raise ValueError("cyPAPI has not been initialized.\n")

# test querying PAPI preset define
try:
    define = PAPI_TOT_INS
    define_is_countable = cyPAPI_query_event(define)
except:
    raise ValueError("Failed querying PAPI preset define.")

# test querying PAPI preset hexadecimal
try:
    hex_code = 0x80000066 # corresponds to PAPI_FP_OPS
    hex_is_countable = cyPAPI_query_event(hex_code)
except:
    raise ValueError("Failed querying PAPI preset hexadecimal.")

# test querying PAPI preset decimal
try:
    decimal_code = -2147483632 # corresponds to PAPI_BRU_IDL
    decimal_is_countable = cyPAPI_query_event(decimal_code)
except:
    raise ValueError("Failed querying PAPI preset decimal.")

# test querying native event code
try:
    # 0 corresponds to CPU native events
    enum_ntv = CyPAPI_enum_component_events(0)
    ntv_code = enum_ntv.next_event()
    ntv_is_countable = cyPAPI_query_event(ntv_code)
except:
    raise ValueError("Failed querying native event code.")

# output if all cyPAPI conversions were successful
print(f"{cyPAPI_event_code_to_name(define)} is {'countable' if define_is_countable == 0 else 'not countable'}.")
print(f"{cyPAPI_event_code_to_name(hex_code)} is {'countable' if hex_is_countable == 0 else 'not countable'}.")
print(f"{cyPAPI_event_code_to_name(decimal_code)} is {'countable' if decimal_is_countable == 0 else 'not countable'}.")
print(f"{cyPAPI_event_code_to_name(ntv_code)} is {'countable' if ntv_is_countable == 0 else 'not countable'}.")
print("\033[0;32mPASSED\033[0m")
