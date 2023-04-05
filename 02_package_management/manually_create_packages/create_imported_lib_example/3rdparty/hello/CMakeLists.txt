cmake_minimum_required(VERSION 3.20)

project(hello)

add_library(hello STATIC
    hello.hpp
    hello.cpp
)