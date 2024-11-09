cmake_minimum_required(VERSION 3.10)
project(x)

# set(CMAKE_POSITION_INDEPENDENT_CODE ON) # This is required, 
add_library(otherlib STATIC otherlib.cpp)
target_compile_features(otherlib PUBLIC cxx_std_11)

add_library(mylib SHARED mylib.cpp)
target_link_libraries(mylib PUBLIC otherlib)

add_executable(main main.cpp)
target_link_libraries(main PUBLIC mylib)