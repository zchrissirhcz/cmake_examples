cmake_minimum_required(VERSION 3.20)
project(x)

set(CMAKE_BUILD_TYPE debug)

#----------------------------------------------------------------------
# Global setting, set Debug build type's postfix
#----------------------------------------------------------------------
set(CMAKE_DEBUG_POSTFIX "_d")

add_library(hello STATIC
  hello.h
  hello.cpp
)


add_library(world STATIC
  world.h
  world.cpp
)
#----------------------------------------------------------------------
# Target-level settings, set Debug build type's postfix
#----------------------------------------------------------------------
set_target_properties(world PROPERTIES DEBUG_POSTFIX "__debug")
