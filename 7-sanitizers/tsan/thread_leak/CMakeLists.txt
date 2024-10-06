cmake_minimum_required(VERSION 3.5)
project(thread_leak)

set(CMAKE_CXX_STANDARD 11)
add_executable(test test.cpp)
target_compile_options(test PRIVATE -fsanitize=thread -fno-omit-frame-pointer -g)
target_link_options(test PRIVATE -fsanitize=thread)

