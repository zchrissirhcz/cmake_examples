cmake_minimum_required(VERSION 3.20)

project(use_ceres)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include("cmake/overlook.cmake")
include("cmake/deps.cmake")


add_executable(testbed testbed.cpp)
target_link_libraries(testbed
  Ceres::ceres
)
