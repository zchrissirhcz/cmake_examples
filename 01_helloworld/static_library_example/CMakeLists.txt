cmake_minimum_required(VERSION 3.20)
project(helloworld)
add_library(hello STATIC
  hello.h
  hello.cpp
)

# Let's use the created static library, the `hello` target
add_executable(hello_test hello_test.cpp)
target_link_libraries(hello_test hello)