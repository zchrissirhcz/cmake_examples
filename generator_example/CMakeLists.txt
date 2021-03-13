cmake_minimum_required(VERSION 3.15)

project(hello)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(testbed
    hello.cpp
)
