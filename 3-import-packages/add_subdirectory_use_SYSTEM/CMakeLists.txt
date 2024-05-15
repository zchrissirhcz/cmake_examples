cmake_minimum_required(VERSION 3.25)
project(x)

#add_subdirectory(hello) # this will cause compile error when processing hello.h
add_subdirectory(hello SYSTEM) # this will suppress compile error when processing hello.h
add_executable(test_hello test_hello.cpp)
if(CMAKE_SYSTEM_NAME MATCHES "Windows")
  target_compile_options(test_hello PRIVATE /we6244 /we6246 /we4457 /we4456)
else()
  target_compile_options(test_hello PRIVATE -Werror=shadow)
endif()

target_link_libraries(test_hello PRIVATE hello)
