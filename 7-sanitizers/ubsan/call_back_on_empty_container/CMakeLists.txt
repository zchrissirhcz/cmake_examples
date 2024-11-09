cmake_minimum_required(VERSION 3.10)
project(call_back_on_empty_container)

add_executable(test test.cpp)
target_compile_options(test PRIVATE -fsanitize=undefined -fno-omit-frame-pointer -g)
target_link_options(test PRIVATE -fsanitize=undefined)
