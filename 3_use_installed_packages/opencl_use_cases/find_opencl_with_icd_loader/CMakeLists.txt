cmake_minimum_required(VERSION 3.20)

project(use_opencl)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include(cmake/deps.cmake)

# OpenCL Headers
# https://github.com/KhronosGroup/OpenCL-Headers.git
set(OpenCLHeaders_DIR "${ARTIFACTS_DIR}/OpenCL-Headers/share/cmake/OpenCLHeaders")
find_package(OpenCLHeaders REQUIRED)

# OpenCL Library
if(CMAKE_SYSTEM_NAME MATCHES "Darwin")
  message(STATUS "On MacOS we use the system OpenCL")
  find_package(OpenCL REQUIRED)
else()
  # OpenCL ICD Loader: https://github.com/KhronosGroup/OpenCL-ICD-Loader.git
  if(CMAKE_SYSTEM_NAME MATCHES "Linux")
    set(OpenCLICDLoader_DIR "${ARTIFACTS_DIR}/OpenCL-ICD-Loader/linux-x64/share/cmake/OpenCLICDLoader")
  elseif(ANDROID)
    set(OpenCLICDLoader_DIR "${ARTIFACTS_DIR}/OpenCL-ICD-Loader/android-arm64/share/cmake/OpenCLICDLoader")
  else()
    message(FATAL_ERROR "not supported for finding opencl yet")
  endif()
  find_package(OpenCLICDLoader REQUIRED)
endif()

add_executable(testbed
  testbed.cpp
)
target_link_libraries(testbed
  PRIVATE
    OpenCL::Headers OpenCL::OpenCL
)
