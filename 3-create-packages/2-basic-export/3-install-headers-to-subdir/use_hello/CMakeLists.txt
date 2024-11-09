cmake_minimum_required(VERSION 3.10)
project(use_hello C)
set(hello_DIR "${CMAKE_SOURCE_DIR}/../hello/build/install/cmake/hello"
  CACHE PATH "The directory that contains hello-config.cmake")
find_package(hello REQUIRED)
add_executable(use_hello use_hello.c)
target_link_libraries(use_hello PRIVATE hello)