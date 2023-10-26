cmake_minimum_required(VERSION 3.20)
project(run_python)

# include(FindPythonInterp) # This is deprecated since CMake 3.12
find_package (Python3 COMPONENTS Interpreter)

set(py_cmd "hello.py")
execute_process(
  COMMAND ${Python3_EXECUTABLE} ${py_cmd}
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  RESULT_VARIABLE py_result
  OUTPUT_VARIABLE py_output
)
message(STATUS "Python result: ${py_result}")
message(STATUS "Python output: ${py_output}")
