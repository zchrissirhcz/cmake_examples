cmake_minimum_required(VERSION 3.10)
project(foo)

add_library(foo foo.cpp)
find_package (Eigen3 3.3 REQUIRED NO_MODULE)
target_link_libraries(foo PRIVATE Eigen3::Eigen)
target_compile_definitions(foo PRIVATE Eigen=fooEigen) # this change Eigen's symbols which avoid potential conflict
