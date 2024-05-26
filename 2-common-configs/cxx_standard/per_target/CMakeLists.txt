cmake_minimum_required(VERSION 3.20)
project(example)

add_executable(main ${CMAKE_CURRENT_SOURCE_DIR}/../../src/main.cpp)

set_target_properties(main PROPERTIES
  CXX_STANDARD 17
)