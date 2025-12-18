from setuptools import setup, Extension
from Cython.Build import cythonize
import os, subprocess
import numpy

def configure_extension_module(extension_module: Extension, papi_build_parent_directory: str):
    # Handle PAPI install include directory
    papi_install_include_directory = os.path.join(f"{os.getcwd()}", papi_build_parent_directory, "include")
    extension_module.include_dirs.append(papi_install_include_directory)

    # Handle PAPI install lib directory
    papi_install_lib_directory = os.path.join(f"{os.getcwd()}", papi_build_parent_directory, "lib")
    extension_module.library_dirs.append(papi_install_lib_directory)

    # Handle runtime libraries, this is needed for libpapi.so and libpfm4.so to be found at runtime
    extension_module.runtime_library_dirs.append(papi_install_lib_directory)

def search_environment_variable(environment_path: str):
    for environment_directory in environment_path.split(":"):
        try:
            if "libpapi.so" in os.listdir(environment_directory):
                # Return the parent directory to properly construct the extension module
                return os.path.dirname(environment_directory)
        # Catch FileNotFoundError, but continue on to other directories
        except FileNotFoundError:
            pass

if os.name == "nt":
    raise NotImplementedError("cyPAPI does not support Windows Operating Systems.")


extension_module_papi = Extension( "cypapi.cypapi",
                                   sources = ["cypapi/cypapi.pyx"],
                                   libraries = ["papi"],
                                   include_dirs = [numpy.get_include()],
                                   define_macros = [("NPY_NO_DEPRECATED_API", "NPY_1_7_API_VERSION")] )

# Search for PAPI build
# Check to see if a user set PAPI_DIR, this overrides all other options
papi_build_parent_directory = os.environ.get("PAPI_DIR")
if papi_build_parent_directory is None:
     # Check LIBRARY_PATH for PAPI build
     library_path = os.environ.get("LIBRARY_PATH")
     if library_path is not None:
         papi_build_parent_directory = search_environment_variable(library_path)

     # Check LD_LIBRARY_PATH for PAPI build 
     ld_library_path = os.environ.get("LD_LIBRARY_PATH")
     if ld_library_path is not None and papi_build_parent_directory is None:
         papi_build_parent_directory = search_environment_variable(ld_library_path)


     # Search through /opt/ for a PAPI build
     if papi_build_parent_directory is None:
         opt_path = "/opt"
         papi_in_opt_found = None
         for directory in os.listdir(opt_path):
             if "papi" in directory:
                 find_command = f"find {os.path.join(opt_path, directory)} -type d -exec test -e '{{}}'/bin -a -e '{{}}'/include -a -e '{{}}'/lib -a -e '{{}}'/share \; -print"
                 completed_process = subprocess.run(find_command, shell = True, check = True, capture_output = True)

                 decoded_process_stdout = completed_process.stdout.strip().decode("utf-8")
                 if decoded_process_stdout:
                     papi_build_parent_directory = decoded_process_stdout
                     break;

# No PAPI build found, clone PAPI from master https://github.com/icl-utk-edu/papi.git and build default components
if papi_build_parent_directory is None:
    papi_build_parent_directory = os.path.join(os.getcwd(), "papi/src/papi_build_for_cypapi")
    if not os.path.isdir("papi"): 
        clone_and_build_papi_command = ("git clone https://github.com/icl-utk-edu/papi.git;"
                                        "cd papi/src;"
                                        f"./configure --prefix={papi_build_parent_directory};"
                                        "make && make install")

        subprocess.run(clone_and_build_papi_command, shell = True)
    else:
        if not os.path.exists(papi_build_parent_directory):
            raise FileNotFoundError("Unable to clone papi from the master branch and build with the default components as a papi directory already exists."
                                    " Please set PAPI_DIR to your papi build directory.")

configure_extension_module(extension_module_papi, papi_build_parent_directory)

internal_compile_time_envs = {}
cuda_compiled_in_command = f"{papi_build_parent_directory}/bin/papi_component_avail | sed -n '/Compiled-in components:/,/Active components:/p' | grep 'Name:   cuda'"
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
    ext_modules = cythonize([extension_module_papi], compile_time_env = internal_compile_time_envs),
    install_requires = ['numpy'],
)
