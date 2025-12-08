cdef extern from "papi_cuda_std_event_defs.h":
    cdef int _PAPI_CUDA_FP16_FMA "PAPI_CUDA_FP16_FMA" # Cuda half precision (FP16) FMA instructions
    cdef int _PAPI_CUDA_BF16_FMA "PAPI_CUDA_BF16_FMA" # Cuda half precision (BF16) FMA instructions
    cdef int _PAPI_CUDA_FP32_FMA "PAPI_CUDA_FP32_FMA" # Cuda single precision (FP32) FMA instructions
    cdef int _PAPI_CUDA_FP64_FMA "PAPI_CUDA_FP64_FMA" # Cuda double precision (FP64) FMA instructions
    cdef int _PAPI_CUDA_FP_FMA   "PAPI_CUDA_FP_FMA"   # Cuda floating point FMA instructions
    cdef int _PAPI_CUDA_FP8_OPS   "PAPI_CUDA_FP8_OPS" # Cuda 8-bit precision floating-point operations
