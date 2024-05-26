cmake_minimum_required(VERSION 3.25)
project(hello)

add_library(hello STATIC
    hello.h
    hello.cpp
)
target_include_directories(hello PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)