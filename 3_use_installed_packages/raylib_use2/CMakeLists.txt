cmake_minimum_required(VERSION 3.20)
project(games)
set(CMAKE_CXX_STANDARD 11)

if(CMAKE_SYSTEM_NAME MATCHES "Darwin")
  set(raylib_src_dir "/Users/zz/work/github/raylib")
elseif(CMAKE_SYSTEM_NAME MATCHES "Windows")
  set(raylib_src_dir "C:/users/zz/work/raylib")
elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
  set(raylib_src_dir "/home/zz/work/github/raylib")
endif()
add_subdirectory(${raylib_src_dir} raylib)

# core_basic_window
add_executable(core_basic_window
  core_basic_window.cpp
)
target_link_libraries(core_basic_window PUBLIC raylib)