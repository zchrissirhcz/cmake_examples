cmake_minimum_required(VERSION 3.10)
project(x)

option(ENABLE_LOGGING "enable logging?" ON)
message(STATUS "ENABLE_LOGGING: ${ENABLE_LOGGING}")

if(ENABLE_LOGGING)
  add_compile_definitions(ENABLE_LOGGING)
endif()

add_executable(test test.cpp)
