cmake_minimum_required(VERSION 3.20)
project(sleek_test)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 11)

include("${CMAKE_CURRENT_SOURCE_DIR}/../../sleek.cmake")

sleek_add_asan_flags()

add_executable(testbed testbed.cpp)

sleek_print_target_properties(testbed)

sleek_print_cxx_flags()
sleek_print_linker_flags()