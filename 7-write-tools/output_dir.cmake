# Author: Zhuo Zhang <imzhuo@foxmail.com>
# Homepage: https://github.com/zchrissirhcz
# Created:  2023-04-26 15:50:01
# Last update: 2023-09-22 15:20:00

if(OUTPUT_DIR_INCLUDE_GUARD)
  return()
endif()
set(OUTPUT_DIR_INCLUDE_GUARD 1)

# Save libs and executables in the same directory
# MSVC will have value for EXECUTABLE_OUTPUT_PATH on default. Now we ignore it.
if(NOT EXECUTABLE_OUTPUT_PATH)
  set(EXECUTABLE_OUTPUT_PATH "${CMAKE_BINARY_DIR}" CACHE PATH "Output directory for applications")
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${EXECUTABLE_OUTPUT_PATH} CACHE INTERNAL "") # static
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${EXECUTABLE_OUTPUT_PATH} CACHE INTERNAL "") # shared
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${EXECUTABLE_OUTPUT_PATH} CACHE INTERNAL "") # exe
endif()