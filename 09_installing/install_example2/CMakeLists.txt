#------------------------------------------------------------
# setup default install directory
# (must in the beginning)
#------------------------------------------------------------
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
    set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install" CACHE PATH "Installation Directory")
endif()
message(STATUS "CMAKE_INSTALL_PREFIX = ${CMAKE_INSTALL_PREFIX}")


cmake_minimum_required(VERSION 3.15)

project(Foo)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

add_library(foo STATIC
    foo.h
    foo.cpp
)

# 设定target的 PUBLIC_HEADER 属性后， install 命令才会安装 PUBLIC_HEADER 包含的头文件
# 默认安装到 include 目录
set_target_properties(foo PROPERTIES
    PUBLIC_HEADER
        "foo.h"   # 对于单个头文件，可以不用双引号
                  # 如果有多个公共头文件，放在变量里，那么用这个变量时要用双引号，否则无效
)

install(TARGETS foo)

