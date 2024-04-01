# cyPAPI: A Python API for PAPI permormance measurement

## What is PAPI?

The Performance Application Programming Interface ([PAPI](https://icl.utk.edu/papi/)) supplies a consistent interface and methodology for collecting performance counter information from various hardware and software components, including most major CPUs, GPUs, accelerators, interconnects, I/O systems, and power interfaces, as well as virtual cloud environments.

## What is cyPAPI?

`cyPAPI` provides a convenient interface for Python programs to access PAPI profiling features with minimum overhead. It supports PAPI version >= 7.0.0.0

## Installation

Currently `cyPAPI` supports installation from source. From the source root execute `make install`.

## Install requires

- Cython
- C compiler
- PAPI library installed
    - First checks if user has set `PAPI_PATH` environment variable pointing to the location of PAPI installation
    - Then it checks if pkg-config utility can locate PAPI installation
    - Then it relies on `C_INCLUDE_PATHS` & `LIBRARY_PATHS` to be used by compiler
    - It also looks for papi library in `LD_LIBRARY_PATH`
    - Lastly it expects that PAPI is installed in default OS installation paths

## Usage

```
from cypapi import *

PyPAPI_library_init()

eventset = PyPAPI_EventSet()

eventset.add_named_event('PAPI_TOT_CYC')
eventset.add_named_event('PAPI_TOT_INS')

eventset.start()

# Do some computation

values = eventset.stop()

print(values)
```
