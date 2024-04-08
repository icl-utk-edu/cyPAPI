# cyPAPI

A Python API which provides a convenient interface to access [PAPI](https://icl.utk.edu/papi/) profiling features with minimum overhead. Currently cyPAPI supports PAPI version >= 7.0.0.

## What is PAPI?

The Performance Application Programming Interface (PAPI) supplies a consistent interface and methodology for collecting performance counter information from various hardware and software components, including most major CPUs, GPUs, accelerators, interconnects, I/O systems, and power interfaces, as well as virtual cloud environments.

## Installation

To use cyPAPI: <br>

Clone the cyPAPI respoitory with the following command:

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

- Cython
- Numpy
- C compiler, e.g. gcc
- PAPI library installed, if not installed see the following [link](https://github.com/icl-utk-edu/papi/wiki/Downloading-and-Installing-PAPI)
    - First checks if user has set `PAPI_PATH` environment variable pointing to the location of PAPI installation
    - Then it checks if pkg-config utility can locate PAPI installation
    - Then it relies on `C_INCLUDE_PATHS` & `LIBRARY_PATHS` to be used by compiler
    - It also looks for papi library in `LD_LIBRARY_PATH`
    - Lastly it expects that PAPI is installed in default OS installation paths

