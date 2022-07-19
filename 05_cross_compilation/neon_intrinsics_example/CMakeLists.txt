cmake_minimum_required(VERSION 3.20)

project(neon_intrinsics_example)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include("cmake/overlook.cmake")
include("cmake/dependencies.cmake")

add_executable(testbed testbed.cpp)


