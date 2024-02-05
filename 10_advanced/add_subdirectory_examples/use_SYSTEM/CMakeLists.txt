cmake_minimum_required(VERSION 3.25)
project(x)

#add_subdirectory(hello) # this will cause compile error when processing hello.h
add_subdirectory(hello SYSTEM) # this will suppress compile error when processing hello.h
add_executable(test_hello test_hello.cpp)
target_compile_options(test_hello PRIVATE -Werror=shadow)

target_link_libraries(test_hello PRIVATE hello)
