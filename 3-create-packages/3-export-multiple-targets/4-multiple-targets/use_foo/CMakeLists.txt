cmake_minimum_required(VERSION 3.5)
project(use_foo C)
set(foo_DIR "${CMAKE_SOURCE_DIR}/../foo/build/install/cmake"
  CACHE PATH "The directory that contains foo-config.cmake")
find_package(foo REQUIRED)
add_executable(use_foo use_foo.c)
target_link_libraries(use_foo PRIVATE foo::hello foo::add)