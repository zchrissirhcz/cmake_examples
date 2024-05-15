cmake_minimum_required(VERSION 3.20)

project(q)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(hello)

add_executable(testbed testbed.cpp)
target_link_libraries(testbed PUBLIC
  deps::hello
)