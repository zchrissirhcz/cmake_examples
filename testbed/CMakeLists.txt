cmake_minimum_required(VERSION 3.15)

project(demo)

if(APPLE)
    set(ZLIB_DIR "/Users/chris/soft/zlib/1.2.11" CACHE PATH "")
    set(MY_MODULE_DIR "/Users/chris/work/cmake_examples/modules")
elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
    set(ZLIB_DIR "/home/zz/soft/zlib/1.2.11" CACHE PATH "")
    set(MY_MODULE_DIR "/home/zz/work/cmake_examples/modules")
endif()

#set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})
#list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/modules)
list(INSERT CMAKE_MODULE_PATH 0 ${MY_MODULE_DIR})

set(ZLIB_SHARED ON)
find_package(ZLIB REQUIRED)

add_executable(demo
    src/demo.cpp
)

target_link_libraries(demo ZLIB)

