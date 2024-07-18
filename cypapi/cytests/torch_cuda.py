#!/usr/bin/env python3

# imports necessary for script
import torch

import cypapi as cyp

if __name__ == '__main__':
    # size of tensors
    m_rows = 1000
    n_cols = 1000

    # check to see if a device is available
    if torch.cuda.is_available():
        unit = "cuda"
    else:
        raise ValueError("NVIDIA device needed.")

    try:
        # initialize cyPAPI
        cyp.cyPAPI_library_init(cyp.PAPI_VER_CURRENT)

        # check to see if cyPAPI was successfully initialized
        if cyp.cyPAPI_is_initialized() != 1:
            raise ValueError( "cyPAPI has not been initialized.\n" )

        # create  a cyPAPI EventSet 
        cuda_eventset = cyp.CypapiCreateEventset()

        # get cuda component index
        cidx = cyp.cyPAPI_get_component_index(unit)
    
        # collect cuda native event
        cuda_cmp = cyp.CypapiEnumCmpEvent(cidx)
        cuda_evt_code = cuda_cmp.next_event()
        cuda_evt_name = cyp.cyPAPI_event_code_to_name(cuda_evt_code)

        # add cuda native event to the EventSet
        cuda_eventset.add_event(cuda_evt_code)
 
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
     # Cuda component was not successfully built
    except Exception:
        print('\033[0;31mFAILED\033[0m');
        raise
    # Cuda component has been successfully built
    else:
        # show number of available devices
        print( "Number of available devices: ", torch.cuda.device_count() )
        # show device name
        print( "Device Name: ", torch.cuda.get_device_name( unit ) )
        # counts for cuda native event 
        print( f"Hardware Counts for {cuda_evt_name}:", hw_counts[0])
        print("\033[0;32mPASSED\033[0m")
