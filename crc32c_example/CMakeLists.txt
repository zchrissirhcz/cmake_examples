cmake_minimum_required(VERSION 3.15)

project(demo)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(demo
    src/main.cpp
)

set(Crc32c_DIR "D:/lib/crc32c/lib/cmake/Crc32c" CACHE PATH "directory that contains Crc32cConfig.cmake")
find_package(Crc32c REQUIRED)
target_link_libraries(demo Crc32c::crc32c)