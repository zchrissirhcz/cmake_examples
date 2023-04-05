cmake_minimum_required(VERSION 3.20)
project(glfw_example)
set(CMAKE_CXX_STANDARD 11)

add_executable(testbed
  main.cpp
)

find_package(glfw3 REQUIRED)
find_package(OpenGL REQUIRED)

target_link_libraries(testbed PUBLIC
  glfw
  OpenGL::GL
)