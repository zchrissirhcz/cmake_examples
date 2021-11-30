cmake_minimum_required(VERSION 3.20)
project(cursor_demo)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake-modules/")
find_package(LibClang REQUIRED)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${LIBCLANG_CXXFLAGS}")

add_executable(cursor_demo
    main.cpp
)
target_link_libraries(cursor_demo ${LIBCLANG_LIBRARIES})


# 拷贝文件
add_custom_command(TARGET cursor_demo
    POST_BUILD

    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    ${CMAKE_SOURCE_DIR}/header.hpp
    ${CMAKE_BINARY_DIR}/
)