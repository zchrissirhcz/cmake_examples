cmake_minimum_required(VERSION 2.8)

project(cuda-demo)

set(CMAKE_CXX_STANDARD 11)

set(CUDA_TOOLKIT_ROOT_DIR "E:/soft/NVIDIA GPU Computing Toolkit/CUDA/v10.1")
include("deps.cmake")

# nvcc flags
# 如果是Release模式，则可以用这些option; 如果是debug模式，则会报错
#set(CUDA_NVCC_FLAGS -O3;-G;-g)

#set(CUDA_NVCC_FLAGS -gencode arch=compute_20,code=sm_20;-G;-g)
#set(CUDA_NVCC_FLAGS -gencode arch=compute_52,code=sm_52;-G;-g)

cuda_add_executable(demo src/array_add.cu)
target_link_libraries(demo
    ${CUDA_LIBS}
)
target_include_directories(demo 
    PUBLIC ${CUDA_INCLUDE_DIR}
)

