from setuptools import setup, Extension
from Cython.Build import cythonize
import os, subprocess
import numpy

def get_papi_path_pkg_config():
    import pkgconfig
    try:
        papi_path = pkgconfig.variables('cypapi')['prefix']
    except pkgconfig.pkgconfig.PackageNotFoundError:
        papi_path = None
    return papi_path

def get_papi_path_env_var(path_var: str):
    lib_path = os.environ.get(path_var)
    if not lib_path:
        return None
    for path in lib_path.split(':'):
        if any(['libpapi' in item for item in os.listdir(path)]):
            return os.path.dirname(path)

def configure_extension(ext: Extension, papi_path: str):
    papi_inc = os.path.join(papi_path, 'include')
    papi_lib = os.path.join(papi_path, 'lib')

    ext.include_dirs.append(papi_inc)
    ext.library_dirs.append(papi_lib)
    ext.runtime_library_dirs.append(papi_lib)

if os.name == 'nt':
    raise NotImplementedError('cypapi does not currently support Windows OS')

ext_papi = Extension('cypapi.cypapi', sources=['cypapi/cypapi.pyx'], libraries=['papi'], include_dirs=[numpy.get_include()], define_macros=[("NPY_NO_DEPRECATED_API", "NPY_1_7_API_VERSION")])

papi_path = os.environ.get('PAPI_DIR')
if not papi_path:
    papi_path = get_papi_path_pkg_config()
if not papi_path:
    papi_path = get_papi_path_env_var('LIBRARY_PATH')
if not papi_path:
    papi_path = get_papi_path_env_var('LD_LIBRARY_PATH')

if papi_path:
    configure_extension(ext_papi, papi_path)

internal_compile_time_envs = {}
cuda_compiled_in_command = f"{papi_path}/bin/papi_component_avail | sed -n '/Compiled-in components:/,/Active components:/p' | grep 'Name:   cuda'"
# Check to see if the cuda component was compiled in
try:
    completed_process = subprocess.run(cuda_compiled_in_command, shell = True, check = True, capture_output = True)
# Cuda component was not compiled into PAPI
except subprocess.CalledProcessError:
    internal_compile_time_envs["CUDA_COMPILED_IN"] = False
# Cuda component was compiled into PAPI
else:
    internal_compile_time_envs["CUDA_COMPILED_IN"] = True

setup(
    name='cypapi',
    packages=['cypapi'],
    ext_modules = cythonize([ext_papi], compile_time_env = internal_compile_time_envs),
    install_requires = ['numpy'],
)
