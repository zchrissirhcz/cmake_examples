cmake_minimum_required(VERSION 3.20)
project(example)

#----------------------------------------------------------------------
# method 1
#----------------------------------------------------------------------
# The recommended way
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

#----------------------------------------------------------------------
# method 2
#----------------------------------------------------------------------
# not working for Visual Studio. not recommended
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")

#----------------------------------------------------------------------
# method 3
#----------------------------------------------------------------------
# not working for Visual Studio. not recommended
#add_compile_options(-fPIC)

#----------------------------------------------------------------------
# method4, per target
#----------------------------------------------------------------------
# add_library(hello hello.cpp)
# set_property(TARGET hello PROPERTY POSITION_INDEPENDENT_CODE ON)