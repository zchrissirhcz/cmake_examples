cmake_minimum_required(VERSION 3.20)
project(example)

set(CMAKE_CXX_STANDARD 17)
add_executable(main ${CMAKE_CURRENT_SOURCE_DIR}/../../src/main.cpp)
