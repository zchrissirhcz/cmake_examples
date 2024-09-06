cmake_minimum_required(VERSION 3.5)
project(x)

add_executable(test
  objc_interface.h
  objc_interface.mm
  main.cpp
)

find_library(COCOA_LIBRARY Cocoa REQUIRED)
target_link_libraries(test PRIVATE ${COCOA_LIBRARY})
