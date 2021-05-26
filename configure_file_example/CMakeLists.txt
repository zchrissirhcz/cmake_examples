cmake_minimum_required(VERSION 3.17)

#project(hello VERSION 1.0) 不推荐这种写法，这样定义的是 hello_VERSION_MAJOR 等于 1，太死板。我想要大写的 HELLO_VERSION_MAJOR

project(hello)

set(HELLO_VERSION_MAJOR 1)
set(HELLO_VERSION_MINOR 0)
configure_file(hello_config.h.in hello_config.h)

add_executable(hello hello.cpp)
target_include_directories(hello PUBLIC "${PROJECT_BINARY_DIR}")
