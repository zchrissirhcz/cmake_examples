cmake_minimum_required(VERSION 3.20)
project(example)

#----------------------------------------------------------------------
# The best pratice, for Globally Setting
set(CMAKE_CXX_STANDARD 11)
#----------------------------------------------------------------------

add_executable(main main.cpp)

#----------------------------------------------------------------------
# Only for target:
#----------------------------------------------------------------------
set_target_properties(main PROPERTIES
  CXX_STANDARD 14
)