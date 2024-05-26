cmake_minimum_required(VERSION 3.20)

project(gflags_use)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(gflags_DIR "D:/artifacts/gflags/2.2.2/windows/vs2019-x64/lib/cmake/gflags")

find_package(gflags REQUIRED)
if(gflags_FOUND)
  message(STATUS "===== Found gflags")
  message(STATUS "----- GFLAGS_INCLUDE_DIR: ${GFLAGS_INCLUDE_DIR}")
endif()

add_executable(testbed testbed.cpp)
target_link_libraries(testbed gflags)


