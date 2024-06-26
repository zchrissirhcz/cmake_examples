cmake_minimum_required(VERSION 3.5)
project(x)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/install)
set(CMAKE_BUILD_TYPE Release)

add_library(hello STATIC hello.c)

install(
  TARGETS hello
  DESTINATION lib
)
install(
  FILES hello.h
  DESTINATION include
)