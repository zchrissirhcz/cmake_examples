cmake_minimum_required(VERSION 3.20)
project(x)

add_executable(demo main.cpp)

# LINK_LIBRARIES: -ldl
#target_link_libraries(demo PRIVATE ${CMAKE_DL_LIBS})

# LINK_LIBRARIES: -ldl
target_link_libraries(demo PRIVATE dl)

# We don't need an variable that stores the path of dlfcn.h header file
# Because dlfcn.h is in the same directory of stdio.h