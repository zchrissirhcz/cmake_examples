cmake_minimum_required(VERSION 3.15)

project(demo)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(demo src/demo.cpp)

find_package(PNG REQUIRED)

target_link_libraries(demo PNG::PNG)

