cmake_minimum_required(VERSION 3.10)

project(coverage_example)
set(CMAKE_CXX_COMPILER g++)

add_executable(testbed hello.cpp)

target_compile_options(testbed PUBLIC -fprofile-arcs -ftest-coverage)
target_link_libraries(testbed PUBLIC -fprofile-arcs)

#target_compile_options(testbed PUBLIC -coverage -fprofile-arcs -ftest-coverage)
#target_link_libraries(testbed PUBLIC -coverage -lgcov)
