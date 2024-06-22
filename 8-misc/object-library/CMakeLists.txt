cmake_minimum_required(VERSION 3.25)
project(x)
add_library(mylib 
  OBJECT # here
  mylib.cpp
)
add_executable(test main.cpp)
target_link_libraries(test PRIVATE mylib)
