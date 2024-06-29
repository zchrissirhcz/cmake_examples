cmake_minimum_required(VERSION 3.5)
project(foo)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
add_library(foo STATIC foo.c)
target_include_directories(foo PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

message(STATUS foos)