cmake_minimum_required(VERSION 3.20)
project(run_python)

# include(FindPythonInterp) # This is deprecated since CMake 3.12
find_package (Python3 COMPONENTS Interpreter)

set(raw_py_cmd "${Python3_EXECUTABLE} hello.py -p linux -a aarch64")
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
