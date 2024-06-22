cmake_minimum_required(VERSION 3.20)
project(x)

set(CMAKE_BUILD_TYPE debug)

# https://stackoverflow.com/questions/31038963/how-do-you-rename-a-library-filename-in-cmake

add_library(hello STATIC
  hello.h
  hello.cpp
)

#----------------------------------------------------------------------
# method 1: set prefix
#----------------------------------------------------------------------
# set_target_properties(hello PROPERTIES PREFIX "my_")

#----------------------------------------------------------------------
# method 2: set output name.
# For a library target, final file name consits of: PREFIX OUTPUT_NAME SUFFIX
#----------------------------------------------------------------------
set_target_properties(hello PROPERTIES OUTPUT_NAME "better_name")

#----------------------------------------------------------------------
# method 2: set suffix
#----------------------------------------------------------------------
# set_target_properties(hello PROPERTIES SUFFIX ".so.1")



add_library(world STATIC
  world.h
  world.cpp
)

add_executable(testbench testbench.cpp)
target_link_libraries(testbench PUBLIC
    hello
    world
)
#----------------------------------------------------------------------
# method 2: set output name for an executable target
# the final file name is same as ${OUTPUT_NAME}
#----------------------------------------------------------------------
set_target_properties(testbench PROPERTIES OUTPUT_NAME "what")