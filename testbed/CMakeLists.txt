cmake_minimum_required(VERSION 3.15)

project(demo)

#set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})
#list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/modules)
list(INSERT CMAKE_MODULE_PATH 0 /Users/chris/work/cmake_examples/modules)

set(ZLIB_DIR "/Users/chris/soft/zlib/1.2.11" CACHE PATH "")
find_package(ZLIB REQUIRED)

add_executable(demo
    src/demo.cpp
)

target_link_libraries(demo ZLIB)

