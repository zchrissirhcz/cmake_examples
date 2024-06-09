cmake_minimum_required(VERSION 3.25)
project(x)

# set(CMAKE_POSITION_INDEPENDENT_CODE ON) # This is required, 
add_library(otherlib STATIC otherlib.cpp)

add_library(mylib SHARED mylib.cpp)
target_link_libraries(mylib PUBLIC otherlib)

add_executable(main main.cpp)
target_link_libraries(main PUBLIC mylib)