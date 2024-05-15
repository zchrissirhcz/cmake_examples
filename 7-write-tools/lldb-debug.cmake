# Author: Zhuo Zhang <imzhuo@foxmail.com>
# Homepage: https://github.com/zchrissirhcz
# Last update: 2023-09-22 15:20:00

if(LLDB_DEBUG_INCLUDE_GUARD)
  return()
endif()
set(LLDB_DEBUG_INCLUDE_GUARD 1)

if((CMAKE_C_COMPILER_ID MATCHES "Clang") OR (CMAKE_CXX_COMPILER_ID MATCHES "Clang"))
  set(lldb_required_debug_flag -g -fstandalone-debug)
  add_compile_options(${lldb_required_debug_flag})
  add_link_options(${lldb_required_debug_flag})
  message(STATUS ">>> USE_LLDB_DEBUG: YES")
else()
  message(STATUS ">>> USE_LLDB_DEBUG: NO")
endif()
