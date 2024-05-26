cmake_minimum_required(VERSION 3.25)
project(peach_tree)

add_executable(peach_tree peach.cpp)

# Get EasyX from https://easyx.cn/download
set(easyx_root "${CMAKE_CURRENT_SOURCE_DIR}/../prebuilt/EasyX_20240225")
add_library(easyx STATIC IMPORTED GLOBAL)
set_target_properties(easyx PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES "${easyx_root}/include"
  IMPORTED_LOCATION "${easyx_root}/lib/VC2015/x64/EasyXa.lib"
)

target_link_libraries(peach_tree PRIVATE easyx)
