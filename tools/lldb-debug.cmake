# last update: 2023/04/22

if((CMAKE_C_COMPILER_ID MATCHES "Clang") OR (CMAKE_CXX_COMPILER_ID MATCHES "Clang"))
  set(lldb_required_debug_flag -g -fstandalone-debug)
  add_compile_options(${lldb_required_debug_flag})
  add_link_options(${lldb_required_debug_flag})
  message(STATUS ">>> USE_LLDB_DEBUG: YES")
else()
  message(STATUS ">>> USE_LLDB_DEBUG: NO")
endif()
