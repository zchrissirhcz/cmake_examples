cmake_minimum_required(VERSION 3.20)
project(x)

add_library(foo STATIC
  foo.h
  foo.c
)
target_link_libraries(foo PRIVATE m)

add_library(hello STATIC
  hello.h
  hello.c
)
target_link_libraries(hello PRIVATE foo)


add_executable(testbed testbed.c)
target_link_libraries(testbed PUBLIC hello)
