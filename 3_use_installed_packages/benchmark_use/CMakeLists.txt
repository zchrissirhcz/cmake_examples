cmake_minimum_required(VERSION 3.20)
project(use_benchmark)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(benchmark_DIR "E:/artifacts/benchmark/1.6.0/vs2019-x64/lib/cmake/benchmark")
find_package(benchmark REQUIRED CONFIG)

#----------------------------------------------------------------------
# testbed
#----------------------------------------------------------------------
add_executable(testbed
    testbed.cpp
)

target_link_libraries(testbed benchmark::benchmark)


#----------------------------------------------------------------------
# testbed2
#----------------------------------------------------------------------
add_executable(testbed2
    testbed2.cpp
)

target_link_libraries(testbed2 benchmark::benchmark)


#----------------------------------------------------------------------
# testbed3
#----------------------------------------------------------------------
add_executable(testbed3
    testbed3.cpp
)
