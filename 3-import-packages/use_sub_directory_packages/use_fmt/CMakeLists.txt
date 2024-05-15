cmake_minimum_required(VERSION 3.20)
project(x)

#set(fmt_src_dir "../fmt")
set(fmt_src_dir "/home/zz/work/github/fmt")
add_subdirectory(${fmt_src_dir} ${CMAKE_BINARY_DIR}/fmt)

add_executable(testbed main.cpp)
target_link_libraries(testbed PUBLIC fmt::fmt)
