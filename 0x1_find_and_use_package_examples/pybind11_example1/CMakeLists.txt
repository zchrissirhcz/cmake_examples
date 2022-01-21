cmake_minimum_required(VERSION 3.15)

project(demo)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_BUILD_TYPE "Release")

add_subdirectory(pybind11)
pybind11_add_module(eight_queens_fast src/main.cpp)
