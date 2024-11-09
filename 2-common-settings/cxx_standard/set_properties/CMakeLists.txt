cmake_minimum_required(VERSION 3.10)
project(x)

add_executable(hello hello.cpp)
set_property(TARGET hello PROPERTY CXX_STANDARD 17)
