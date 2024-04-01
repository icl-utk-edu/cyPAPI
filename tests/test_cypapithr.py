from cypapi import *
from cypapithr import *
import time

pyPAPI_library_init()
pyPAPI_thread_init()

evt_set = PyPAPI_EventSet()
evt_set.add_named_event('nvml:::Tesla_V100-SXM2-32GB:device_0:power')
evt_set.add_named_event('nvml:::Tesla_V100-SXM2-32GB:device_0:memory_utilization')
evt_set.add_named_event('nvml:::Tesla_V100-SXM2-32GB:device_0:gpu_utilization')

sampler = ThreadSamplerEventSet(evt_set, interval_ms=20)
sampler.start()
time.sleep(0.4)
data = sampler.stop()
print(data)
sampler.reset()  # Remove this to measure and append data in series

time.sleep(5)
sampler.start()
time.sleep(0.4)
data = sampler.stop()
data[:, 0] = data[:, 0] - data[0, 0]
print(data)
