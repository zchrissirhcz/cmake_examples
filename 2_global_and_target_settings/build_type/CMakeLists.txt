cmake_minimum_required(VERSION 3.20)
project(exmaple)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

message(STATUS ">>> FLAGS for all build types:")
message(STATUS ">>>     CMAKE_C_FLAGS: ${CMAKE_C_FLAGS}")
message(STATUS ">>>     CMAKE_CXX_FLAGS: ${CMAKE_CXX_FLAGS}")
message(STATUS ">>>     CMAKE_LINKER_FLAGS: ${CMAKE_LINKER_FLAGS}")

if(NOT (CMAKE_BUILD_TYPE EQUAL "None" OR NOT CMAKE_BUILD_TYPE))
  message(STATUS ">>> Build Type: ${CMAKE_BUILD_TYPE}")
  string(TOUPPER "${CMAKE_BUILD_TYPE}" capitalized_build_type)
  message(STATUS ">>> CONFIG: ${capitalized_build_type}")
  message(STATUS ">>> Capitalized Build Type: ${capitalized_build_type}")
  message(STATUS ">>> CMAKE_CXX_FLAGS_<CONFIG>: ${CMAKE_CXX_FLAGS_${capitalized_build_type}}")
endif()

add_library(hello STATIC hello.cpp)