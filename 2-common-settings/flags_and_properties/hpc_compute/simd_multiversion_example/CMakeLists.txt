cmake_minimum_required(VERSION 3.20)
project(hello)

set(SIMD_ARCH "sse4.2")
#set(SIMD_ARCH "avx2")

add_executable(testbed testbed.cpp)

if(SIMD_ARCH STREQUAL "sse4.2")
    set(SIMD_FLAG "-msse4.2")
elseif(SIMD_ARCH STREQUAL "avx")
    set(SIMD_FLAG "-mavx")
elseif(SIMD_ARCH STREQUAL "avx2")
    set(SIMD_FLAG "-mavx2")
endif()

target_compile_options(testbed PUBLIC ${SIMD_FLAG})


