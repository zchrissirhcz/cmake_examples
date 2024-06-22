cmake_minimum_required(VERSION 3.5)
project(use_hello)

add_subdirectory(hello)
add_executable(use_hello use_hello.cpp)
target_link_libraries(use_hello PRIVATE hello)