cmake_minimum_required(VERSION 3.20)
project(example)

# The recommended way
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# not working for Visual Studio. not recommended
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")

# not working for Visual Studio. not recommended
#add_compile_options(-fPIC)