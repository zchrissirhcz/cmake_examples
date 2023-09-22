# Author: Zhuo Zhang <imzhuo@foxmail.com>
# Homepage: https://github.com/zchrissirhcz
# Last update: 2023-09-22 15:20:00

if(WINDOWS_ENCODING_INCLUDE_GUARD)
  return()
endif()
set(WINDOWS_ENCODING_INCLUDE_GUARD 1)

if(CMAKE_C_COMPILER_ID STREQUAL "MSVC" OR CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
  # This solves Visual Studio warning C4819
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /source-charset:utf-8")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /source-charset:utf-8")

  if(CMAKE_VERSION VERSION_LESS "3.24")
    include(FindPythonInterp)
    execute_process(
      COMMAND ${PYTHON_EXECUTABLE} "${CMAKE_SOURCE_DIR}/cmake/QueryCodePage.py"
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
      RESULT_VARIABLE ReturnCode
      OUTPUT_VARIABLE CodePage
    )
  else() # CMake >= 3.24
    cmake_host_system_information(
      RESULT CodePage
      QUERY WINDOWS_REGISTRY "HKLM/SYSTEM/CurrentControlSet/Control/Nls/CodePage"
      VALUE "ACP"
    )
  endif()

  message(STATUS "CodePage is: ${CodePage}")
  if("${CodePage}" STREQUAL "936")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /execution-charset:gbk")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /execution-charset:gbk")
  endif()

  set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} /bigobj")
endif()
