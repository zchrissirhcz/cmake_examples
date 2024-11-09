cmake_minimum_required(VERSION 3.10)
project(memory_leak)

add_executable(test test.cpp)
target_compile_options(test PRIVATE -fsanitize=address -fno-omit-frame-pointer -g)
target_link_options(test PRIVATE -fsanitize=address)

