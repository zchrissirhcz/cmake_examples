cmake_minimum_required(VERSION 3.10)
project(MyStaticProgram)

# 设置全局静态链接
set(CMAKE_EXE_LINKER_FLAGS "-static")
set(CMAKE_CXX_FLAGS "-static-libgcc -static-libstdc++")
set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
set(BUILD_SHARED_LIBS OFF)

# 查找静态库
find_package(SomeLibrary STATIC REQUIRED)

# 添加可执行文件
add_executable(my_program main.cpp)

# 链接到静态库
target_link_libraries(my_program
  -static
  -Wl,--whole-archive
  some_static_library
  -Wl,--no-whole-archive
)