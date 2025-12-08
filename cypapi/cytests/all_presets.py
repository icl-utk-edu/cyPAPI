#!/usr/bin/env python3

# imports necessary for script
import cypapi as cyp
from do_loops import do_flops

if __name__ == '__main__':
    # Initialize cyPAPI library
    cyp.cyPAPI_library_init(cyp.PAPI_VER_CURRENT)

    eventCode = 0 | cyp.PAPI_PRESET_MASK
    modifier = cyp.PAPI_PRESET_ENUM_AVAIL
    while True:
        # Create an evenset for the presets (CPU and/or GPU) to be added to
        try:
            eventSet = cyp.CypapiCreateEventset()
        except Exception:
            print('\033[0;31mFAILED\033[0m')
            raise

        # Enumerate through the PAPI presets (CPU and/or GPU)
        try:
            entry, eventCode = cyp.cyPAPI_enum_event(eventCode, modifier)
        # If either a CypapiEinval or CypapiEnoevnt exception is hit, break
        except (cyp.CypapiEinval, cyp.CypapiEnoevnt):
            eventSet.destroy_eventset()
            break
        except Exception:
            print('\033[0;31mFAILED\033[0m')
            raise

        # A workflow of: adding a preset (CPU and/or GPU), starting, stopping, cleaning up and destroying the eventset
        try:
            eventSet.add_event(eventCode)

            eventSet.start()
            do_flops()
            eventSet.stop()

            eventSet.cleanup_eventset()
            eventSet.destroy_eventset()
        except Exception:
           print('\033[0;31mFAILED\033[0m')
           raise
        else:
            print(f"Successfully added, start, and stopped: {[*entry][0]}")

    # Everything ran successfully
    print('\033[0;32mPASSED\033[0m'); 
