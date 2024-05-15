cmake_minimum_required(VERSION 3.15)

project(demo)

set(Matlab_ROOT_DIR "D:/soft/Matlab/R2020a" CACHE PATH "Matlab root directory")

find_package(Matlab REQUIRED)

matlab_add_mex(
    NAME my_add
    SRC 
        src/main.cpp
        src/add.cpp
        src/add.h
)
