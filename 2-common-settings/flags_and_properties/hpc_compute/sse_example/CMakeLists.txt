cmake_minimum_required(VERSION 3.15)

project(demo)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# https://stackoverflow.com/a/50939506/2999096
add_library(sse4_1 INTERFACE IMPORTED)
if(MSVC)
    target_compile_options(sse4_1 INTERFACE /arch:SSE4.1)
else()
    target_compile_options(sse4_1 INTERFACE -msse4.1)
endif()

add_executable(fast_ceil
	src/fast_ceil.cpp
)

target_link_libraries(fast_ceil sse4_1)
