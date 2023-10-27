cmake_minimum_required(VERSION 3.20)
project(run_python)

# include(FindPythonInterp) # This is deprecated since CMake 3.12
# find_package(Python3 REQUIRED COMPONENTS Interpreter) # works in native build, fails if cross building
if(CMAKE_CROSSCOMPILING)
  cmake_policy(SET CMP0148 OLD)
  set(PYTHON_EXECUTABLE "python")
  include(FindPythonInterp)
else()
  find_package(Python3 REQUIRED COMPONENTS Interpreter)
  set(PYTHON_EXECUTABLE ${Python3_EXECUTABLE})
endif()

set(py_cmd "hello.py")
execute_process(
  COMMAND ${Python3_EXECUTABLE} ${py_cmd}
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  RESULT_VARIABLE py_result
  OUTPUT_VARIABLE py_output
)
message(STATUS "Python result: ${py_result}")
message(STATUS "Python output: ${py_output}")
