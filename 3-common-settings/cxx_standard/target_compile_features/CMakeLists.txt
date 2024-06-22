cmake_minimum_required(VERSION 3.20)
project(example)

add_executable(main ${CMAKE_CURRENT_SOURCE_DIR}/../../src/main.cpp)

target_compile_features(main PRIVATE cxx_std_17)