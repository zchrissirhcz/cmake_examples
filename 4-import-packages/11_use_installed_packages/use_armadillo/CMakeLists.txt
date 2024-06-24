cmake_minimum_required(VERSION 3.20)

project(armadillo_use)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(DEFINED ENV{ARTIFACTS_DIR})
  set(ARTIFACTS_DIR "$ENV{ARTIFACTS_DIR}")
else()
  message(WARNING "ARTIFACTS_DIR env var not defined")
endif()

set(Armadillo_DIR "${ARTIFACTS_DIR}/armadillo/11.2.x/linux-x64/share/Armadillo/CMake")
find_package(Armadillo REQUIRED CONFIG)

add_executable(testbed testbed.cpp)
target_link_libraries(testbed armadillo)

