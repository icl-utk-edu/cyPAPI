Introduction
============

``cypapi`` enables profiling and measurement of hardware counters from Python code.
It wraps the ``papi`` `(Performance Application Programmer Interface)`

Installation
------------

Prerequisites
~~~~~~~~~~~~~

You must have ``papi`` installed in your system and the ``cypapi`` installer should be
able to locate it. To install PAPI you can follow the instructions at the 
`PAPI homepage <https://github.com/icl-utk-edu/papi>`_.

The installer tries each of the following methods in order

- ``PAPI_PATH`` environment variable
  - ``export PAPI_PATH=/path/to/installed/papi/library``

- If `pkgconfig` tool can locate PAPI

- If PAPI exists in the standard environment variables of C compiler
  - ``C_INCLUDE_PATHS`` & ``LIBRARY_PATHS``

- If path to PAPI shared libraries exist in ``LD_LIBRARY_PATH``

- Lastly, if PAPI is installed in standard system paths that can be located by C compilers

Install from source
~~~~~~~~~~~~~~~~~~~

You can clone the ``cypapi`` repository and from this path you can use pip to install 
it in your active Python environment

    ``$ pip install .``
