cmake_minimum_required(VERSION 3.20)
project(run_python)

include(FindPythonInterp)
set(py_cmd "hello.py")
execute_process(
  COMMAND ${PYTHON_EXECUTABLE} ${py_cmd}
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  RESULT_VARIABLE py_result
)
message(STATUS "Python result: ${py_result}")