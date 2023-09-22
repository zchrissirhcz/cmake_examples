# Author: Zhuo Zhang <imzhuo@foxmail.com>
# Homepage: https://github.com/zchrissirhcz
# Last update: 2023-09-22 15:20:00

if(IGNORE_NO_PDB_WARNING_INCLUDE_GUARD)
  return()
endif()
set(IGNORE_NO_PDB_WARNING_INCLUDE_GUARD 1)

#set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "/ignore:4099")
if(CMAKE_SYSTEM_NAME MATCHES "Windows")
  add_link_options("/ignore:4099")
endif()