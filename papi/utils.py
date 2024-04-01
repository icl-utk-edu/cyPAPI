from cypapi import *

def papi_component_avail():
    num_cmp = pyPAPI_num_components()
    for cidx in range(num_cmp):
        cmp = PyPAPI_get_component_info(cidx)
        if cmp.disabled and cmp.disabled != PAPI_Error['PAPI_EDELAYINIT']:
            print(f'Component {cidx}: {cmp.name}\n\tDescription:\t{cmp.description}')
            print(f'\tDisabled {cmp.disabled}:\t{cmp.disabled_reason}')
            continue
        if cmp.disabled == PAPI_Error['PAPI_EDELAYINIT']:
            events = PyPAPI_enum_component_events(cidx)
            next(events)

        cmp = PyPAPI_get_component_info(cidx)
        print(f'Component {cidx}: {cmp.name}\n\tDescription:\t{cmp.description}')
        if cmp.disabled:
            print(f'\tDisabled:\t{cmp.disabled_reason}')
        else:
            print(f'\tNum events:\t{cmp.num_native_events}')

def papi_avail(opt=None):
    """Get a list of CPU preset events.
    
    Arg:
        opt - An option that can be one of the following
        
        'all'
        'avail'
        'msc'
        'ins'
        'idl'
        'br'
        'cnd'
        'mem'
        'cach'
        'l1'
        'l2'
        'l3'
        'tlb'
        'fp'
    """
    for evtcode in PyPAPI_enum_preset_events(opt):
        evtname = pyPAPI_event_code_to_name(evtcode)
        evtdescr = pyPAPI_event_code_to_descr(evtcode)
        print(evtname, evtdescr)

def papi_native_avail(cidx):
    return [pyPAPI_event_code_to_name(evt_code)
            for evt_code in PyPAPI_enum_component_events(cidx)
    ]

if __name__ == '__main__':
    if not pyPAPI_is_initialized():
        pyPAPI_library_init()
    papi_component_avail()
