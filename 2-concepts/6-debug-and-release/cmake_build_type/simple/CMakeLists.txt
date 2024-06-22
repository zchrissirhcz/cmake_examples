cmake_minimum_required(VERSION 3.5)
project(x)

# specify and print build type, right after the first call of `project()`
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()