cmake_minimum_required(VERSION 3.15)

project(demo)
set(CMAKE_BUILD_TYPE "Release")

add_executable(demo
    src/main.cpp
)

# https://stackoverflow.com/questions/68727478/why-cvparallel-for-run-faster-than-my-own-implementation
# https://gitlab.kitware.com/cmake/cmake/-/issues/21725
# https://github.com/Tencent/ncnn/pull/3175
# https://github.com/Tencent/ncnn/issues/3174
find_package(OpenMP)
if(NOT TARGET OpenMP::OpenMP_CXX AND (OpenMP_CXX_FOUND OR OPENMP_FOUND))
    target_compile_options(demo PUBLIC ${OpenMP_CXX_FLAGS})
endif()

if(OpenMP_CXX_FOUND OR OPENMP_FOUND)
    if(ANDROID_NDK_MAJOR AND (ANDROID_NDK_MAJOR GREATER 20))
        target_compile_options(demo PUBLIC -fopenmp)
        target_link_libraries(demo PUBLIC -fopenmp -static-openmp)
    elseif(OpenMP_CXX_FOUND)
        target_link_libraries(demo PUBLIC OpenMP::OpenMP_CXX)
    else()
        target_link_libraries(demo PUBLIC "${OpenMP_CXX_FLAGS}")
    endif()
endif()