cmake_minimum_required(VERSION 3.15)

project(demo)
set(CMAKE_BUILD_TYPE "Release")

add_executable(demo
    src/main.cpp
)


find_package(OpenMP)
if(NOT TARGET OpenMP::OpenMP_CXX AND (OpenMP_CXX_FOUND OR OPENMP_FOUND))
    target_compile_options(demo PRIVATE ${OpenMP_CXX_FLAGS})
endif()

if(OpenMP_CXX_FOUND OR OPENMP_FOUND)
    if(ANDROID_NDK_MAJOR AND (ANDROID_NDK_MAJOR GREATER 20))
        target_compile_options(demo PRIVATE -fopenmp)
        target_link_libraries(demo PUBLIC -fopenmp -static-openmp)
    elseif(OpenMP_CXX_FOUND)
        target_link_libraries(demo PUBLIC OpenMP::OpenMP_CXX)
    else()
        target_link_libraries(demo PRIVATE "${OpenMP_CXX_FLAGS}")
    endif()
endif()