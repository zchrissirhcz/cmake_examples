cmake_minimum_required(VERSION 3.20)

project(hello)

set(HELLO_VERSION_MAJOR 1)
set(HELLO_VERSION_MINOR 0)
configure_file(hello_config.h.in hello_config.h)

add_executable(hello hello.cpp)
target_include_directories(hello PUBLIC "${PROJECT_BINARY_DIR}")
