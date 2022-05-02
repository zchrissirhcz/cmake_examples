cmake_minimum_required(VERSION 3.20)
project(ThreadSanitizer_Example)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_BUILD_TYPE Debug)

include(../tsan.cmake)


add_executable(testbed
  #testbed.cpp # will cause data race, TSan will report it
  testbed2.cpp # resolve data race with mutex and lock guard
)
target_link_libraries(testbed pthread)
