
#设置源代码utf-8格式，控制台运行时采用gbk格式
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC" OR CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
  set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   /source-charset:utf-8 /execution-charset:gbk")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /source-charset:utf-8 /execution-charset:gbk")
endif()
