cmake_minimum_required(VERSION 3.15)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

project(hello)

add_library(hello STATIC
    ${CMAKE_SOURCE_DIR}/hello.h
    ${CMAKE_SOURCE_DIR}/hello.cpp
)
