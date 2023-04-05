cmake_minimum_required(VERSION 3.17)
project(header_only_library_example)

add_library(array INTERFACE
    array.hpp
)

add_executable(use_array
    use_array.cpp
)

target_link_libraries(use_array array)