cmake_minimum_required(VERSION 3.25)
project(read_txt_file)

add_executable(demo demo.cpp)

set_target_properties(
  demo PROPERTIES
  VS_DEBUGGER_WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
)