# CMake Debugging

## 1. print 大法
Use `message`
```cmake
# 常规输出， 相当于 printf
message(STATUS "-- CMAKE_BUILD_TYPE is: ${CMAKE_BUILD_TYPE}")

# 错误输出， 相当于 fprintf(stderr, ) 加上 exit()/abort, 立即停止运行
message(FATAL_ERROR "-- CMAKE_BUILD_TYPE is: ${CMAKE_BUILD_TYPE}")
```

## 2. verbose 输出
CMakeLists.txt
```cmake
cmake_minimum_required(VERSION 3.20)
project(blabla)

set(CMAKE_VERBOSE_MAKEFILE ON) # !! 增加这句
```
随后执行 make 时会生成 link.txt, 里面列出了详细的链接参数.

## 3. find_package 输出详细信息
从cmake3.17开始，文档里正式说明支持CMAKE_FIND_DEBUG_MODE这一cmake变量，设定为TRUE则打印find_package/find_program/find_file等函数的打印过程

```cmake
set(CMAKE_FIND_DEBUG_MODE TRUE)

find_package(...)

set(CMAKE_FIND_DEBUG_MODE FALSE)
```

## 4. ccmake/cmake-gui 查看 CMakeCache.txt
toggle 一些 variable 的显示。在 find_package() 失败时候有一些帮助。

## 5. 查看 <Pkg>Config.cmake 等文件
`find_package()` 后， 使用 package 时的写法往往容易出问题， 写法都是不统一的。
查看 `<Pkg>Config.cmake`以及 `<Pkg>Targets.cmake` 等文件（通常）可以获得正确的 target 写法。

## 6. 判断 TARGET 是否存在
```cmake
find_package(OpenCL REQUIRED)

if(TARGET OpenCL::OpenCL)
  message(STATUS "Yes, target OpenCL::OpenCL is defined")
else()
  message(STATUS "Nope, not defined OpenCL::OpenCL")
endif()
```