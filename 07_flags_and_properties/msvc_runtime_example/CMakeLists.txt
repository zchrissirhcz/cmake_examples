cmake_minimum_required(VERSION 3.20)

# 设置策略CMP0091为NEW，新策略
if (POLICY CMP0091)
  cmake_policy(SET CMP0091 NEW)
endif (POLICY CMP0091)

# 声明一个工程
project(msvc_runtime_example)

# 添加一个exe
add_executable(testbed testbed.cpp)

# 设置MT/MTd
set_property(TARGET testbed PROPERTY
  MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

