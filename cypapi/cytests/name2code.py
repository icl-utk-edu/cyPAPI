#!/usr/bin/env python3

# importing necessary functions
from cypapi import *

# initialize cyPAPI library
cyPAPI_library_init()

# check to make sure cyPAPI has been intialized
if cyPAPI_is_initialized() != 1:
    raise ValueError("cyPAPI has not been initialized.\n")

# test converting PAPI preset event name to code
try:
    evt_preset_name = "PAPI_TOT_INS"
    evt_preset_code = cyPAPI_event_name_to_code(evt_preset_name)
except:
    raise ValueError("Failed converting PAPI preset event name to code.")

# test converting native event name to code
try:
    # retrieve cpu native event name
    enum_ntv = CyPAPI_enum_component_events(0)
    ntv_code = enum_ntv.next_event()
    evt_ntv_name = cyPAPI_event_code_to_name(ntv_code)
    # convert cpu native event name to code
    evt_ntv_code = cyPAPI_event_name_to_code(evt_ntv_name)
except:
    raise ValueError("Failed converting native event name to code.")

# output if all cyPAPI conversions were successful
print(f"Eventcode for {evt_preset_name}: ", evt_preset_code)
print(f"Eventcode for  {evt_ntv_name}:", evt_ntv_code)
print("\033[0;32mPASSED\033[0m")
