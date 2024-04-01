import sys
import ctypes
from cypapi import *
from cysdelib import unpack_i64_float

# Load the C library and get the API
# Might also be wraped so that we can do
# `from simple2 import simple_init, simple_compute`
simple_lib = ctypes.cdll.LoadLibrary('./libSimple2.so')

def simple_init():
    return simple_lib.simple_init()

def simple_compute(x: float):
    return simple_lib.simple_compute(ctypes.c_double(x))

# Proceed with test
low_mark = [ 0,  2,  2,  7, 21,  29,  29,  29,  29,  34]
high_mark = [ 1,  1,  2,  3,  4,   8,   9,   9,   9,  13]
tot_iter = [ 2,  9, 13, 33, 83, 122, 126, 130, 135, 176]
comp_val = [0.653676, 3.160483, 4.400648, 10.286250, 25.162759, 36.454895, 37.965891, 39.680220, 41.709039, 53.453990]

def setup_PAPI():
    pyPAPI_library_init()

    cidx = pyPAPI_get_component_index('sde')
    if cidx < 0:
        raise RuntimeError('SDE component not installed with PAPI')

    event_set = PyPAPI_EventSet()

    event_set.add_named_event('sde:::Simple2::LOW_WATERMARK_REACHED')
    event_set.add_named_event('sde:::Simple2::HIGH_WATERMARK_REACHED')
    event_set.add_named_event('sde:::Simple2::ANY_WATERMARK_REACHED')
    event_set.add_named_event('sde:::Simple2::TOTAL_ITERATIONS')
    event_set.add_named_event('sde:::Simple2::COMPUTED_VALUE')

    return event_set

if __name__ == '__main__':

    discrepancies = 0
    be_verbose = False

    if len(sys.argv) > 1 and sys.argv[1] in ('--verbose', '-v'):
        be_verbose = True

    simple_init()

    event_set = setup_PAPI()

    event_set.start()

    for i in range(10):
        sum = simple_compute(0.87 * i)

        if be_verbose:
            print(f'{sum=}')

        counter_values = event_set.read()

        counter_values[4] = unpack_i64_float(counter_values[4])

        if be_verbose:
            print(f'Low watermark={counter_values[0]}, High watermark={counter_values[1]}, ', end='')
            print(f'Any watermark={counter_values[2]}, Total iterations={counter_values[3]}, ', end='')
            print(f'Comp. Value={counter_values[4]}')

        if (counter_values[0] != low_mark[i] or
        counter_values[1] != high_mark[i] or
        counter_values[2] != (low_mark[i] + high_mark[i]) or
        counter_values[3] != tot_iter[i] or
        counter_values[4]-2.0*comp_val[i] > 0.00001 or
        counter_values[4]-2.0*comp_val[i] < -0.00001):
            discrepancies += 1

    counter_values = event_set.stop()
    if discrepancies:
        assert False, "SDE counter values are wrong!"
