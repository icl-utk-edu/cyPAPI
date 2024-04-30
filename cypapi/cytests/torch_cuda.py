#!/usr/bin/env python3

# import necessary libraries
from cypapi import *

import torch

perrno = PAPI_Error["PAPI_OK"]

# size of tensors
m_rows = 1000
n_cols = 1000

# check to see if a device is available
if torch.cuda.is_available():
    unit = "cuda"
else:
    raise Exception("NVIDIA device needed.")

try:
    # initialize cyPAPI
    cyPAPI_library_init()

    # check to see if cyPAPI was successfully initialized
    if cyPAPI_is_initialized() != 1:
        raise ValueError( "cyPAPI has not been initialized.\n" )

    # create  a cyPAPI EventSet 
    cuda_eventset = CyPAPI_EventSet()

    # get cuda component index
    cidx = cyPAPI_get_component_index( unit )
    
    # collect cuda native event
    cuda_cmp = CyPAPI_enum_component_events( cidx )
    cuda_ntv_evt = cuda_cmp.next_event()

    # add cuda native event to the EventSet
    cuda_eventset.add_event(cuda_ntv_evt)
 
    # start counting hardware events in the created EventSet
    cuda_eventset.start()
    
    # create tensors for computation
    matrix_A = torch.rand( m_rows, n_cols, device = unit )
    matrix_B = torch.rand( m_rows, n_cols, device = unit )
    # perform matrix multiplication
    result_tensor = torch.mm( matrix_A, matrix_B )

    # transfer results to cpu
    result_cpu = result_tensor.detach().cpu()
    
    # stop counting hardware events in the created EventSet
    hw_counts = cuda_eventset.stop()
except:
    perrno = PAPI_Error["PAPI_EINVAL"]

# output if Cuda component has been successfully built
if perrno == PAPI_Error["PAPI_OK"]:
    # show number of available devices
    print( "Number of available devices: ", torch.cuda.device_count() )
    # show device name
    print( "Device Name: ", torch.cuda.get_device_name( unit ) )
    # counts for cuda native event 
    print( f"Hardware Counts for {cyPAPI_event_code_to_name(cuda_ntv_evt)}:", hw_counts[0])
    print("\033[0;32mPASSED\033[0m")
else:
    print("\033[0;31mFAILED\033[0m");
