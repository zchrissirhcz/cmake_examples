cmake_minimum_required(VERSION 3.25)
project(zz)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17")

set(TEST_VAR "test value1" CACHE STRING "test var")
set(TEST_VAR "test value2")
set(TEST_VAR "test value3" CACHE STRING "test var")

message("CMAKE_CXX_FLAGS: ${CMAKE_CXX_FLAGS}")
message("TEST_VAR: ${TEST_VAR}")

add_executable(testbed testbed.cpp)