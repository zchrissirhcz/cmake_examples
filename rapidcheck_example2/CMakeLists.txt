cmake_minimum_required(VERSION 3.20)
project(rapidcheck_example2)
set(CMAKE_CXX_STANDARD 11)

add_subdirectory("rapidcheck")

add_executable(testbed testbed.cpp)
target_link_libraries(testbed rapidcheck)
