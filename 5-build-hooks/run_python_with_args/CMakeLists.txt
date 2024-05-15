cmake_minimum_required(VERSION 3.20)
project(run_python)

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

set(raw_py_cmd "${PYTHON_EXECUTABLE} hello.py -p linux -a aarch64")
string(REPLACE " " ";" py_cmd ${raw_py_cmd})
message(STATUS "raw_py_cmd: ${raw_py_cmd}")
message(STATUS "py_cmd: ${py_cmd}")
execute_process(
  COMMAND ${py_cmd}
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  RESULT_VARIABLE py_result
  OUTPUT_VARIABLE py_output
)
message(STATUS "Python result: ${py_result}")
message(STATUS "Python output: ${py_output}")
