cmake_minimum_required(VERSION 3.20)
project(example)
add_executable(testbed main.cpp)

set(iwyu_path_and_options
    "include-what-you-use" # path
    # options as empty
)

set_property(TARGET testbed
    PROPERTY CXX_INCLUDE_WHAT_YOU_USE ${iwyu_path_and_options})

add_executable(hello hello.cpp)