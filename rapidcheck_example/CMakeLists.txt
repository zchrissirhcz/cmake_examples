cmake_minimum_required(VERSION 3.20)
project(rapidcheck_example)
set(CMAKE_CXX_STANDARD 11)

# Previously compiled rapidcheck static library
set(rapidcheck_DIR "/home/zz/artifacts/rapidcheck/20211010/linux-x64/share/rapidcheck/cmake")
find_package(rapidcheck REQUIRED)

add_executable(testbed testbed.cpp)
# when linking, just linke to `rapidcheck` which is an imported target
target_link_libraries(testbed rapidcheck)
