cmake_minimum_required(VERSION 3.25)
project(peach_tree)

# Get EasyX from https://easyx.cn/download
set(easyx_root "${CMAKE_CURRENT_SOURCE_DIR}/../prebuilt/EasyX_20240225")

add_executable(peach_tree peach.cpp)
target_include_directories(peach_tree PRIVATE
  ${easyx_root}/include
)
target_link_libraries(peach_tree PRIVATE
  ${easyx_root}/lib/VC2015/x64/EasyXa.lib
)