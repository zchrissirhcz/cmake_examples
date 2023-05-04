cmake_minimum_required(VERSION 3.20)
project(x)
add_subdirectory("../fmt" ${CMAKE_BINARY_DIR}/fmt)

add_executable(testbed main.cpp)
target_link_libraries(testbed PUBLIC fmt::fmt)