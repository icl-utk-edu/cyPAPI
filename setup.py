from setuptools import setup, Extension
import os
import numpy

def get_papi_path_pkg_config():
    import pkgconfig
    try:
        papi_path = pkgconfig.variables('papi')['prefix']
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

ext_papi = Extension('cypapi', sources=['papi/cypapi.pyx'], libraries=['papi'], include_dirs=[numpy.get_include()])
ext_sde = Extension('cysdelib', sources=['papi/cysdelib.pyx'], libraries=['papi', 'sde'])
ext_papi_thr = Extension('cypapithr', sources=['papi/threadsampler.pyx'], libraries=['papi'], include_dirs=[numpy.get_include()])

papi_path = os.environ.get('PAPI_PATH')
if not papi_path:
    papi_path = get_papi_path_pkg_config()
if not papi_path:
    papi_path = get_papi_path_env_var('LIBRARY_PATH')
if not papi_path:
    papi_path = get_papi_path_env_var('LD_LIBRARY_PATH')

if papi_path:
    configure_extension(ext_papi, papi_path)
    configure_extension(ext_sde, papi_path)
    configure_extension(ext_papi_thr, papi_path)

setup(
    name = "cypapi",
    version = '0.1',
    description = 'Python interface for the PAPI performance monitoring library',
    author = 'Anustuv Pal',
    author_email = 'anustuv@gmail.com',
    ext_modules = [ext_papi, ext_sde, ext_papi_thr],
    install_requires = ['numpy'],
    packages=[
        'papi'
    ]
)
