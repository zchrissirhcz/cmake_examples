cmake_minimum_required(VERSION 3.17)

project(openmp_example2)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 11)

include(predigest.cmake)
#----------------------------------------------------------------------
# user defined targets
#----------------------------------------------------------------------
add_library(hello STATIC
    hello.h
    hello.cpp
)

add_executable(testbed testbed.cpp)
target_link_libraries(testbed PUBLIC hello)

#----------------------------------------------------------------------
# user targets links to openmp
#----------------------------------------------------------------------
target_link_openmp(hello PRIVATE)
target_link_openmp(testbed PUBLIC)

message(STATUS ">>> outside, OpenMP_CXX_LIBRARIES: ${OpenMP_CXX_LIBRARIES}")
message(STATUS ">>> outside, OpenMP_CXX_FLAGS: ${OpenMP_CXX_FLAGS}")


# get_cmake_property(_variableNames VARIABLES)
# list (SORT _variableNames)
# foreach(_variableName ${_variableNames})
#     message(STATUS "${_variableName}=${${_variableName}}")
# endforeach()
