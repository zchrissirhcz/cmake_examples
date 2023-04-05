cmake_minimum_required(VERSION 3.20)

project(cpuinfo_use_simple)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(DEFINED ENV{ARTIFACTS_DIR})
  set(ARTIFACTS_DIR "$ENV{ARTIFACTS_DIR}")
else()
  message(FATAL_ERROR "ARTIFACTS_DIR env var not defined")
endif()

#--- cpuinfo
if(ANDROID)
  set(cpuinfo_DIR "${ARTIFACTS_DIR}/cpuinfo/master/android-arm64/share/cpuinfo")
elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
  set(cpuinfo_DIR "${ARTIFACTS_DIR}/cpuinfo/master/linux-x64/share/cpuinfo")
elseif(CMAKE_SYSTEM_NAME MATCHES "Darwin")
  set(cpuinfo_DIR "${ARTIFACTS_DIR}/cpuinfo/master/mac-x64/share/cpuinfo")
elseif(CMAKE_SYSTEM_NAME MATCHES "Windows")
  set(cpuinfo_DIR "${ARTIFACTS_DIR}/cpuinfo/master/windows-x64/share/cpuinfo")
else()
  message(WARNING "cpuinfo_DIR not set yet")
endif()
message(STATUS ">>> cpuinfo_DIR: ${cpuinfo_DIR}")
find_package(cpuinfo REQUIRED)


add_executable(testbed testbed.cpp)
target_link_libraries(testbed cpuinfo::cpuinfo)


