##################################
#
# CUDA, cuBLAS, cuDNN, etc
#
##################################
#---------------------------------
# prepare each version of cuda/cublas/cudnn
# assume cuDNN together with CUDA
#---------------------------------

if(CMAKE_SYSTEM_NAME MATCHES "Linux")
    # to use cuBLAS on RTX 2080, we have to use >= CUDA10.1
    set(CUDA_10_1_LIBS
        /usr/lib/x86_64-linux-gnu/libcuda.so # nvidia card driver provide this
        /usr/local/cuda-10.1/lib64/libcudart_static.a
        /usr/lib/x86_64-linux-gnu/libcublas.so
        /usr/local/cuda-10.1/lib64/libcudnn.so
    )
    set(CUDA_10_1_INCLUDE_DIR /usr/local/cuda-10.1/include)

    # if not on RTX 2080, such as GTX 1080Ti, can use cuda10.0, cuda9.0
    set(CUDA_10_0_LIBS
        /usr/lib/x86_64-linux-gnu/libcuda.so
        /usr/local/cuda-10.0/lib64/libcudart_static.a
        /usr/local/cuda-10.0/lib64/libcublas.so
        /usr/local/cuda-10.0/lib64/libcudnn.so
    )
    set(CUDA_10_0_INCLUDE_DIR /usr/local/cuda-10.0/include)

    # cuda9.0 works fine on GTX 970 (tested on Win7) and GTX 1070
    set(CUDA_9_0_LIBS
        /usr/lib/x86_64-linux-gnu/libcuda.so
        /usr/local/cuda-9.0/lib64/libcudart_static.a
        /usr/local/cuda-9.0/lib64/libcublas.so
        /usr/local/cuda-9.0/lib64/libcublas_device.a #cuda9.0 need cublas_device library
        /usr/local/cuda-9.0/lib64/libcudnn.so
    )
    set(CUDA_9_0_INCLUDE_DIR /usr/local/cuda-9.0/include)
elseif(CMAKE_SYSTEM_NAME MATCHES "Windows")
    set(CUDA_10_1_LIBS
        ${CUDA_TOOLKIT_ROOT_DIR}/lib/x64/cuda.lib
        ${CUDA_TOOLKIT_ROOT_DIR}/lib/x64/cudart_static.lib
        ${CUDA_TOOLKIT_ROOT_DIR}/lib/x64/cublas.lib
        ${CUDA_TOOLKIT_ROOT_DIR}/lib/x64/cudnn.lib
    )
    set(CUDA_10_1_INCLUDE_DIR ${CUDA_TOOLKIT_ROOT_DIR}/include)

    # if not on RTX 2080, such as GTX 1080Ti, can use cuda10.0, cuda9.0
    set(CUDA_10_0_LIBS
        ${CUDA_TOOLKIT_ROOT_DIR}/lib/x64/cuda.lib
        ${CUDA_TOOLKIT_ROOT_DIR}/lib/x64/cudart_static.lib
        ${CUDA_TOOLKIT_ROOT_DIR}/lib/x64/cublas.lib
        ${CUDA_TOOLKIT_ROOT_DIR}/lib/x64/cudnn.lib
    )
    set(CUDA_10_0_INCLUDE_DIR ${CUDA_TOOLKIT_ROOT_DIR}/include)

    # cuda9.0 works fine on GTX 970 (tested on Win7) and GTX 1070
    set(CUDA_9_0_LIBS
        ${CUDA_TOOLKIT_ROOT_DIR}/lib/x64/cuda.lib
        ${CUDA_TOOLKIT_ROOT_DIR}/lib/x64/cudart_static.lib
        ${CUDA_TOOLKIT_ROOT_DIR}/lib/x64/cublas.lib
        ${CUDA_TOOLKIT_ROOT_DIR}/lib/x64/cublas_device.lib #cuda9.0 need cublas_device library
        ${CUDA_TOOLKIT_ROOT_DIR}/lib/x64/cudnn.lib
    )
    set(CUDA_9_0_INCLUDE_DIR ${CUDA_TOOLKIT_ROOT_DIR}/include)
endif()

#---------------------------------------------------------------
# please set CUDA_TOOLKIT_ROOT_DIR cache variable before here


if(CUDA_TOOLKIT_ROOT_DIR MATCHES "10.1")
    set(CUDA_INCLUDE_DIR ${CUDA_10_1_INCLUDE_DIR})
    set(CUDA_LIBS ${CUDA_10_1_LIBS})
elseif(CUDA_TOOLKIT_ROOT_DIR MATCHES "10.0")
    set(CUDA_INCLUDE_DIR ${CUDA_10_0_INCLUDE_DIR})
    set(CUDA_LIBS ${CUDA_10_0_LIBS})
elseif(CUDA_TOOLKIT_ROOT_DIR MATCHES "9.0")
    set(CUDA_INCLUDE_DIR ${CUDA_9_0_INCLUDE_DIR})
    set(CUDA_LIBS ${CUDA_9_0_LIBS})
endif()

# we use find_package(CUDA) thus cuda_add_library() / cuda_add_executable() works
find_package(CUDA REQUIRED)
if(CUDA_FOUND)
    message(STATUS "==== Found CUDA")
else()
    message(STATUS "==== could not Found CUDA")
endif()
