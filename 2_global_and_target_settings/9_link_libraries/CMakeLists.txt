cmake_minimum_required(VERSION 3.20)
project(example)

#----------------------------------------------------------------------
# method 1
#----------------------------------------------------------------------
# Globally. Working, but affect all targets.
# Not recommended.
# linking_directories("/usr/local/hello/lib")


add_executable(use_hello use_hello.cpp)

#----------------------------------------------------------------------
# method 2
#----------------------------------------------------------------------
# Working, but stilly not-perfect.
#target_link_directories(use_hello PUBLIC "/usr/local/hello/lib")


#----------------------------------------------------------------------
# method 3
#----------------------------------------------------------------------
# I prefer every target linking required libraries as an package
# set(hello_DIR "/usr/local/hello/lib/cmake" CACHE PATH "")
# find_package(hello REQUIRED)
# target_link_libraries(use_hello PUBLIC hello)


#----------------------------------------------------------------------
# method 4
#----------------------------------------------------------------------
# Or, if the package `hello` does not provide find_package() functionality
# We may just manually make it an package by creating imported library
add_library(hello STATIC IMPORTED GLOBAL)
set_target_properties(easyx PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "/usr/local/hello/include"
    IMPORTED_LOCATION "/usr/local/hello/lib/libhello.a"
)
target_link_libraries(use_hello PUBLIC hello)