cmake_minimum_required(VERSION 3.15)

project(vscode_example)

set(CMAKE_BUILD_TYPE Debug)


include(manage_flags.cmake)
add_debug_symbol()

add_executable(testbed
    src/hello.cpp
)
