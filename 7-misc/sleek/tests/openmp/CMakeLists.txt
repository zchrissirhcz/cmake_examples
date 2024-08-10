cmake_minimum_required(VERSION 3.20)
project(sleek_test)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 11)

include("${CMAKE_CURRENT_SOURCE_DIR}/../../sleek.cmake")

add_executable(testbed testbed.cpp)

#sleek_find_static_package(OpenMP)
#target_link_libraries(testbed OpenMP::OpenMP_CXX)

sleek_target_link_openmp(testbed)
sleek_print_target_properties(testbed)