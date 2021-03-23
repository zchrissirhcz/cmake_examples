cmake_minimum_required(VERSION 3.15)

project(flops)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

enable_language(ASM)

add_executable(testbed.cpp test.S)
