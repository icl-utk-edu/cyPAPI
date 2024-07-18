#!/usr/bin/env python3

# imports necessary for script
import cypapi as cyp
from do_loops import do_flops

if __name__ == '__main__':
    # initialize cyPAPI library
    cyp.cyPAPI_library_init(cyp.PAPI_VER_CURRENT)

    # check to make sure cyPAPI has been intialized
    if cyp.cyPAPI_is_initialized() != 1:
        raise ValueError("cyPAPI has not been initialized.\n")

    # test real time cyPAPI functions
    try: 
        # real time in clock cycles
        rt_cc_start = cyp.cyPAPI_get_real_cyc()
        do_flops()
        rt_cc_stop = cyp.cyPAPI_get_real_cyc()
        # real time in nanoseconds
        rt_ns_start = cyp.cyPAPI_get_real_nsec()
        do_flops()
        rt_ns_stop = cyp.cyPAPI_get_real_nsec()
        # real time in microseconds
        rt_ms_start = cyp.cyPAPI_get_real_usec()
        do_flops()
        rt_ms_stop = cyp.cyPAPI_get_real_usec()
    # collection of real time failed
    except Exception:
        print('\033[0;31mFAILED\033[0m')
        raise
    # collection of real time succeeded
    else:
        print('Real time in clock cycles: ', rt_cc_stop - rt_cc_start)
        print('Real time in nanoseconds: ', rt_ns_stop - rt_ns_start)
        print('Real time in microseconds: ', rt_ms_stop - rt_ms_start)
        print('\033[0;32mPASSED\033[0m');
