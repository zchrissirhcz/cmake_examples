cmake_minimum_required(VERSION 3.15)

project(demo)

add_library(hello SHARED
    src/hello.h
    src/hello.cpp
)

add_executable(demo
    testbed/demo.cpp
)

target_include_directories(demo 
    PUBLIC "${CMAKE_SOURCE_DIR}/src"
)
target_link_libraries(demo hello)