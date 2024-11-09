cmake_minimum_required(VERSION 3.10)
project(signed_integer_overflow_example)

add_executable(test test.cpp)
target_compile_options(test PRIVATE -fsanitize=undefined -fno-omit-frame-pointer -g)
target_link_options(test PRIVATE -fsanitize=undefined)
