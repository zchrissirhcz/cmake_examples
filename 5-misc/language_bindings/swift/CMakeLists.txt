cmake_minimum_required(VERSION 3.20)
project(swift_example)
enable_language(Swift)

add_library(HiKit hikit.swift)
target_include_directories(HiKit INTERFACE
  ${CMAKE_CURRENT_BINARY_DIR}
)

add_executable(testbed
  testbed.swift
)

target_link_libraries(testbed
  HiKit
)