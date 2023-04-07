cmake_minimum_required(VERSION 3.20)
project(x)

set(CMAKE_BUILD_TYPE debug)

# https://stackoverflow.com/questions/31038963/how-do-you-rename-a-library-filename-in-cmake

add_library(hello STATIC
  hello.h
  hello.cpp
)

# prefix
set_target_properties(hello PROPERTIES PREFIX "my_")

# output name
set_target_properties(hello PROPERTIES OUTPUT_NAME "better_name")

# suffix
set_target_properties(hello PROPERTIES SUFFIX ".so.1")



add_library(world STATIC
  world.h
  world.cpp
)

add_executable(testbench testbench.cpp)
target_link_libraries(testbench PUBLIC
    hello
    world
)