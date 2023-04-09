cmake_minimum_required(VERSION 3.20)
project(use_cereal)
set(CMAKE_CXX_STANDARD 11)

include(artifacts.cmake)
set(cereal_DIR "${ARTIFACTS_DIR}/cereal/1.3.2/linux-x64/lib/cmake/cereal")
message(STATUS "cereal_DIR: ${cereal_DIR}")
find_package(cereal REQUIRED)

add_executable(use_cereal use_cereal.cpp)
target_link_libraries(use_cereal PUBLIC cereal::cereal)