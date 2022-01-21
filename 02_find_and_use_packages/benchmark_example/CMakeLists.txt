cmake_minimum_required(VERSION 3.17)

project(benchmark_example)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_BUILD_TYPE Release)


#set(benchmark_DIR "/usr/lib/x86_64-linux-gnu/cmake/benchmark")
if(ANDROID)
    set(benchmark_DIR "/home/zz/artifact/benchmark/android-arm64/lib/cmake/benchmark")
elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
    set(benchmark_DIR "/home/zz/artifact/benchmark/linux-x64/lib/cmake/benchmark")
endif()
find_package(benchmark REQUIRED CONFIG)

add_executable(testbed
    testbed.cpp
)

target_link_libraries(testbed benchmark::benchmark)