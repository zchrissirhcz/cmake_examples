# Author: Zhuo Zhang <imzhuo@foxmail.com>
# Homepage: https://github.com/zchrissirhcz
# Last update: 2023-08-10 05:08:00

# globally
if(MSVC)
  set(CVPKG_DEBUG_FLAGS "/Zi")
elseif((CMAKE_C_COMPILER_ID MATCHES "GNU") OR (CMAKE_CXX_COMPILER_ID MATCHES "GNU"))
  set(CVPKG_DEBUG_FLAGS "-g")
elseif((CMAKE_C_COMPILER_ID MATCHES "Clang") OR (CMAKE_CXX_COMPILER_ID MATCHES "Clang"))
  set(CVPKG_DEBUG_FLAGS "-g -fstandalone-debug")
endif()

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CVPKG_DEBUG_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CVPKG_DEBUG_FLAGS}")

# per-target
# target_compile_options(example_target PRIVATE
#   $<$<CXX_COMPILER_ID:MSVC>:/Zi>
#   $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-g>
# )