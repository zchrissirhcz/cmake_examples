cmake_minimum_required(VERSION 3.17)

project(demo)

set(hello_DIR "/home/zz/work/cmake_examples/install_example2/hello_project/build/install" CACHE PATH "")
find_package(hello REQUIRED)

add_executable(say_hello
    say_hello.cpp
)
message(STATUS "----- hello_INCLUDE_DIR: ${hello_INCLUDE_DIR}")
message(STATUS "----- hello_LIBS: ${hello_LIBS}")
target_include_directories(say_hello PUBLIC ${hello_INCLUDE_DIR})
target_link_libraries(say_hello ${hello_LIBS})