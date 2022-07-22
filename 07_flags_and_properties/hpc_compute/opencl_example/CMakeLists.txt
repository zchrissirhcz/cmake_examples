cmake_minimum_required(VERSION 3.15)

project(testbed)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(OpenCL REQUIRED)

if(OpenCL_FOUND)
    message(STATUS "OpenCL_FOUND: ${OpenCL_FOUND}")
    message(STATUS "OpenCL_INCLUDE_DIRS: ${OpenCL_INCLUDE_DIRS}")
    message(STATUS "OpenCL_LIBRARIES ${OpenCL_LIBRARIES}")
    message(STATUS "OpenCL_VERSION_STRING ${OpenCL_VERSION_STRING}")
    message(STATUS "OpenCL_VERSION_MAJOR ${OpenCL_VERSION_MAJOR}")
    message(STATUS "OpenCL_VERSION_MINOR ${OpenCL_VERSION_MINOR}")
endif()

#[[
-- Found OpenCL: E:/soft/NVIDIA GPU Computing Toolkit/CUDA/v10.2/lib/x64/OpenCL.lib (found version "1.2")
-- OpenCL_FOUND: TRUE
-- OpenCL_INCLUDE_DIRS: E:/soft/NVIDIA GPU Computing Toolkit/CUDA/v10.2/include
-- OpenCL_LIBRARIES E:/soft/NVIDIA GPU Computing Toolkit/CUDA/v10.2/lib/x64/OpenCL.lib
-- OpenCL_VERSION_STRING 1.2
-- OpenCL_VERSION_MAJOR 1
-- OpenCL_VERSION_MINOR 2
#]]

add_executable(testbed
    #testbed.cpp
    matvec.c
    matvec.cl
)

target_link_libraries(testbed OpenCL::OpenCL)