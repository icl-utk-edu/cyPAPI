# cyPAPI

A Python API which provides a convenient interface to access [PAPI](https://icl.utk.edu/papi/) profiling features with minimum overhead. Currently cyPAPI supports PAPI version >= 7.0.0.

## What is PAPI?

The Performance Application Programming Interface (PAPI) supplies a consistent interface and methodology for collecting performance counter information from various hardware and software components, including most major CPUs, GPUs, accelerators, interconnects, I/O systems, and power interfaces, as well as virtual cloud environments.

## Installation

To use cyPAPI: <br>

Clone the cyPAPI repository with the following command:

```bash
git clone https://github.com/icl-utk-edu/cyPAPI.git
```

This will create a complete copy of the cyPAPI git respoitory in a folder titled `cyPAPI`. <br>

Once cyPAPI has been successfully cloned, execute the commands below to install from source:

```bash
cd cyPAPI
make install
```
## Installation Requirements
- PAPI library
    -  cyPAPI takes advantage of existing PAPI functionality such as timers, eventsets, and software defined events. If PAPI is not installed see the following [link](https://github.com/icl-utk-edu/papi/wiki/Downloading-and-Installing-PAPI).

    Note: cyPAPI will check the following locations for PAPI:
    - First checks if the user has set the `PAPI_PATH` environment variable which points to the location of your PAPI installation
    - Then it checks if pkg-config utility can locate the PAPI installation
    - Then it relies on `C_INCLUDE_PATHS` & `LIBRARY_PATHS` to be used by the compiler
    - It also looks for the PAPI library in `LD_LIBRARY_PATH`
    - Lastly it expects that PAPI is installed in default OS installation paths

- Cython
    - Allows access to PAPI profiling features by the support of calling C functions and gives the ease of Python with the speed of native code.

- C compiler, e.g. gcc
    - Cython requires a C compiler to be present on the system such that `.pyx` files can be compiled into C/C++ files respectively. Afterwards the C/C++ files will then be compiled into an extension module which is then directly importable from Python.

- Numpy
    - Internal functions utilize `numpy.ndarrays`. Due to this the Numpy library is a requirement such that installation will be successful. 

