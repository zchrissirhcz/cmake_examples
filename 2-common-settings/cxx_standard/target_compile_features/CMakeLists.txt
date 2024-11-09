cmake_minimum_required(VERSION 3.10)
project(x)

add_executable(hello hello.cpp)
target_compile_features(hello PRIVATE cxx_std_17)
