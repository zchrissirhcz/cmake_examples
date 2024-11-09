cmake_minimum_required(VERSION 3.10)
project(hello C)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_BUILD_TYPE Release)
set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install")

add_library(hello STATIC hello.c)
target_include_directories(hello PUBLIC ${CMAKE_CURRENT_BINARY_DIR})

install(FILES hello.h DESTINATION include)
install(TARGETS hello
  EXPORT hello
  INCLUDES DESTINATION include
)
install(EXPORT hello
  DESTINATION cmake
  FILE hello-config.cmake
)
