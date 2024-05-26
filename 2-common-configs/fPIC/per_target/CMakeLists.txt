cmake_minimum_required(VERSION 3.20)
project(example)
add_library(hello STATIC ${CMAKE_CURRENT_SOURCE_DIR}/../../src/hello.cpp)
set_property(TARGET hello PROPERTY POSITION_INDEPENDENT_CODE ON)