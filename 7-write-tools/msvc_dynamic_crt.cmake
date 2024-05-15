# Author: Zhuo Zhang <imzhuo@foxmail.com>
# Homepage: https://github.com/zchrissirhcz
# Last update: 2023-09-22 15:20:00

# Enables use of dynamically linked CRT
# i.e. use MD / MDd

if(MSVC_DYNAMIC_CRT_INCLUDE_GUARD)
  return()
endif()
set(MSVC_DYNAMIC_CRT_INCLUDE_GUARD 1)

# 设置策略CMP0091为NEW，新策略
if (POLICY CMP0091)
  cmake_policy(SET CMP0091 NEW)
endif (POLICY CMP0091)

if(MSVC AND NOT CMAKE_VERSION VERSION_LESS "3.15")
  # cmake before version 3.15 not work
  set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDLL$<$<CONFIG:Debug>:Debug>")
endif()