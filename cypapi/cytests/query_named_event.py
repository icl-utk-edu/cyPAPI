#!/usr/bin/env python3

# importing necessary functions
from cypapi import *

# initialize cyPAPI library
cyPAPI_library_init()

# check to make sure cyPAPI has been intialized
if cyPAPI_is_initialized() != 1:
    raise ValueError("cyPAPI has not been initialized.\n")

# test querying named PAPI preset event
try:
    preset_name = "PAPI_TOT_INS"
    preset_is_countable = cyPAPI_query_named_event(preset_name)
except:
    raise ValueError("Failed querying named PAPI preset event.")

# test querying named native event
try:
    # 0 corresponds to CPU native events
    enum_ntv = CyPAPI_enum_component_events(0)
    ntv_code = enum_ntv.next_event()
    ntv_name = cyPAPI_event_code_to_name(ntv_code)
    ntv_is_countable = cyPAPI_query_named_event(ntv_name)
except:
    raise ValueError("Failed querying named native event code.")

# output if all cyPAPI conversions were successful
print(f"{preset_name} is {'countable' if preset_is_countable == 0 else 'not countable'}.")
print(f"{ntv_name} is {'countable' if ntv_is_countable == 0 else 'not countable'}.")
print("\033[0;32mPASSED\033[0m")
