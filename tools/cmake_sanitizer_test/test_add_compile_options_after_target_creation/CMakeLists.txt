cmake_minimum_required(VERSION 3.20)
project(t6) # for rule3
add_executable(testbed testbed.cpp)

# the following options won't apply on the target `testbed` !
# check the generated compile_commands.json to verify
add_compile_options(-Werror=literal-conversion -Wall -Wextra -pedantic -Werror)
include("../../summary.cmake")
