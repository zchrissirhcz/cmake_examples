cmake_minimum_required(VERSION 3.15)

project(demo)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_CXX_COMPILER "g++")

option(USE_FPERMISSIVE "use -fpermissive?" ON)

if(USE_FPERMISSIVE)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fpermissive")
endif()

add_executable(demo
    main.cpp
)
