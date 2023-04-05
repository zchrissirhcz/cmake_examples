cmake_minimum_required(VERSION 3.20)
project(example)

# Turn on compile_commands.json generation
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# We have to at least have an target
add_library(hello hello.cpp)

