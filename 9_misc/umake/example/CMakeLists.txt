CMAKE_MINIMUM_REQUIRED(VERSION 3.15)

project(hello)


add_library(hello STATIC
  inc/hello.h
  src/hello.cpp
)

target_include_directories(hello
  PUBLIC inc
)
add_executable(demo
  test/main.cpp
)

target_include_directories(demo
  PUBLIC inc
)
target_link_libraries(demo
   hello
)
