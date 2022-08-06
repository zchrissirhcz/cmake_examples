# Enables use of statically linked CRT for statically linked target
# i.e. use MT / MTd

# 设置策略CMP0091为NEW，新策略
if (POLICY CMP0091)
  cmake_policy(SET CMP0091 NEW)
endif (POLICY CMP0091)

if(MSVC AND NOT CMAKE_VERSION VERSION_LESS "3.15")
  # cmake before version 3.15 not work
  set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
endif()