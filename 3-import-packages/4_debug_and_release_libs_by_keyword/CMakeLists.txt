cmake_minimum_required(VERSION 3.25)
project(say_hello)

set(hello_inc ${CMAKE_CURRENT_SOURCE_DIR}/../prebuilt/hello/inc)
set(hello_lib
  debug     ${CMAKE_CURRENT_SOURCE_DIR}/../prebuilt/hello/lib/vs2022-x64/Debug/hello_d.lib
  optimized ${CMAKE_CURRENT_SOURCE_DIR}/../prebuilt/hello/lib/vs2022-x64/Release/hello.lib
)

add_executable(say_hello say_hello.cpp)
target_include_directories(say_hello PRIVATE ${hello_inc})
target_link_libraries(say_hello PRIVATE ${hello_lib})