cmake_minimum_required(VERSION 3.20)

project(vld_use)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include("${CMAKE_CURRENT_LIST_DIR}/cmake/FindVLD.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/cmake/crtlinkage.cmake")

add_executable(testbed testbed.cpp)

