cmake_minimum_required(VERSION 3.25)
project(use_hello)

add_subdirectory(hello)

add_executable(use_hello ../src/hello_test.cpp)
target_link_libraries(use_hello PRIVATE hello)