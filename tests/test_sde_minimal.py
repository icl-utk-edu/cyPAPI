from cysdelib import *
from cypapi import *

ctr = SdeCounter('Example Event', SDE_RO | SDE_DELTA, int, init=0)

def mintest_init():
    # if not global, the function will call `papi_sde_shutdown` at fn exit
    global handle
    handle = SdeHandle('Min Example Code')
    handle.register_counter(ctr)

def mintest_dowork():
    ctr.value += 7

if __name__ == '__main__':
    mintest_init()

    pyPAPI_library_init()

    event_set = PyPAPI_EventSet()

    event_set.add_named_event('sde:::Min Example Code::Example Event')

    event_set.start()

    mintest_dowork()

    value = event_set.stop()

    if value[0] == 7:
        print('PASS')
    else:
        print('FAIL')
