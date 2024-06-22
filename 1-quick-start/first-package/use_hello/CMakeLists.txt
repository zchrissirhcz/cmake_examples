cmake_minimum_required(VERSION 3.5)
project(use_hello C)
set(hello_DIR "/Users/zz/work/cmake_examples/1-quick-start/first-package/hello/build/install/cmake"
  CACHE PATH "The directory that contains hello-config.cmake")
find_package(hello REQUIRED)
add_executable(use_hello use_hello.c)
target_link_libraries(use_hello PRIVATE hello)

