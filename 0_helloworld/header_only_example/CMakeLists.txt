cmake_minimum_required(VERSION 3.20)
project(header_only_example)

add_subdirectory(autotimer)

add_executable(hello
  hello.cpp
)
target_link_libraries(hello PRIVATE autotimer)