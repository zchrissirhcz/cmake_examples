cmake_minimum_required(VERSION 3.17)

project(openmp_example2)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 11)


option(USE_STATIC_OPENMP "use static openmp?" ON)
option(USE_SHARED_OPENMP "use shared openmp?" OFF)

if(USE_STATIC_OPENMP)
  set(openmp_compile_flag "-fopenmp")
  set(openmp_link_flag "-fopenmp -static-openmp")
elseif(USE_SHARED_OPENMP)
  set(openmp_compile_flag "-fopenmp")
  set(openmp_link_flag "-fopenmp")
endif()


#----------------------------------------------------------------------
# user defined targets
#----------------------------------------------------------------------
add_library(hello STATIC
    hello.h
    hello.cpp
)
target_compile_options(hello PUBLIC ${openmp_compile_flag})
target_link_libraries(hello PUBLIC ${openmp_link_flag})

add_executable(testbed testbed.cpp)
target_link_libraries(testbed PUBLIC hello)

#----------------------------------------------------------------------
# user targets links to openmp
#----------------------------------------------------------------------

message(STATUS ">>> outside, OpenMP_CXX_LIBRARIES: ${OpenMP_CXX_LIBRARIES}")
message(STATUS ">>> outside, OpenMP_CXX_FLAGS: ${OpenMP_CXX_FLAGS}")


# get_cmake_property(_variableNames VARIABLES)
# list (SORT _variableNames)
# foreach(_variableName ${_variableNames})
#     message(STATUS "${_variableName}=${${_variableName}}")
# endforeach()
