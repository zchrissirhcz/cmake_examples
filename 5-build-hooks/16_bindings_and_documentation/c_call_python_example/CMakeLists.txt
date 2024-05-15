cmake_minimum_required(VERSION 3.15)

project(demo)

add_library(hello SHARED
    src/run.h
    src/run.c
    src/main.cpp
)

target_include_directories(
    hello PUBLIC
    E:/soft/Miniconda3/include
)

target_link_directories(hello PUBLIC
    E:/soft/Miniconda3/libs
)