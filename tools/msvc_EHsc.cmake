# Author: Zhuo Zhang <imzhuo@foxmail.com>
# Homepage: https://github.com/zchrissirhcz
# Last update: 2023-07-06 15:16:19

if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
  add_compile_options("/EHsc")
endif()