cmake_minimum_required(VERSION 3.3)
project(doxygen)

# include(FindPythonInterp) # This is deprecated since CMake 3.12
# find_package(Python3 REQUIRED COMPONENTS Interpreter) # works in native build, fails if cross building
if(CMAKE_CROSSCOMPILING)
  cmake_policy(SET CMP0148 OLD)
  set(PYTHON_EXECUTABLE "python")
  include(FindPythonInterp)
else()
  if(CMAKE_SYSTEM_NAME MATCHES "Darwin")
    set(old_cmake_find_framework ${CMAKE_FIND_FRAMEWORK})
    set(CMAKE_FIND_FRAMEWORK LAST)
  endif()
  find_package(Python3 REQUIRED COMPONENTS Interpreter)
  set(PYTHON_EXECUTABLE ${Python3_EXECUTABLE})
  if(CMAKE_SYSTEM_NAME MATCHES "Darwin")
    set(CMAKE_FIND_FRAMEWORK ${old_cmake_find_framework})
  endif()
endif()

enable_testing()
add_subdirectory(testing)
