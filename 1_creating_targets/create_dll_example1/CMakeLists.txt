cmake_minimum_required(VERSION 3.15)

project(demo)

# 开启CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS后，所有符号都被导出（export）
# 避免了手动在每个函数前增加__declspec(dllexport)修饰
# 但也导致所有符号都被外部可见
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

add_library(hello SHARED
    src/hello.h
    src/hello.cpp
)

add_executable(demo
    testbed/demo.cpp
)

target_include_directories(demo 
    PUBLIC "${CMAKE_SOURCE_DIR}/src"
)
target_link_libraries(demo hello)