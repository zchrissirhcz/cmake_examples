cmake_minimum_required(VERSION 3.15)

project(demo)

add_library(hello STATIC
    src/hello.h
    src/hello.c
)

add_executable(testbed
    src/main.cpp
)

target_link_libraries(testbed hello)

