cmake_minimum_required(VERSION 3.5)
project(use_hello C)
set(hello_DIR "${CMAKE_SOURCE_DIR}/../5-solved-by-clean-interface-inc-dirs/hello/build/install/cmake"
  CACHE PATH "The directory that contains hello-config.cmake")
find_package(hello REQUIRED)
add_executable(use_hello use_hello.c)
target_link_libraries(use_hello PRIVATE hello)