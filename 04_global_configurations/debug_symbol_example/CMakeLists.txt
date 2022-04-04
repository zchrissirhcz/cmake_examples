cmake_minimum_required(VERSION 3.20)
project(debug_symbol_exmaple)
set(CMAKE_EXPORT_COMPILE_COMMANDS 1)
set(CMAKE_CXX_STANDARD 11)
add_executable(testbed testbed.cpp)

include(manage_flags.cmake)

print_cxx_flags()

check_exist_debug_symbol()

add_debug_symbol()

check_exist_debug_symbol()

print_cxx_flags()

print_linker_flags()