cmake_minimum_required(VERSION 3.5)
project(x)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_BUILD_TYPE Release)
set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/install)

add_library(hello STATIC
  hello.h
  hello.c
)

set_target_properties(hello PROPERTIES
  PUBLIC_HEADER "hello.h"
)
install(TARGETS hello)