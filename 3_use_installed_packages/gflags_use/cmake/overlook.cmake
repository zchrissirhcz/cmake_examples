###############################################################
#
# OverLook: Amplify C/C++ warnings that shouldn't be ignored.
#
# Author:   Zhuo Zhang <imzhuo@foxmail.com>
# Homepage: https://github.com/zchrissirhcz/overlook
#
###############################################################

cmake_minimum_required(VERSION 3.1)

# Only included once
if(OVERLOOK_INCLUDE_GUARD)
  return()
endif()
set(OVERLOOK_INCLUDE_GUARD TRUE)

set(OVERLOOK_VERSION "2022.04.30")

###############################################################
#
# Useful funtions
#
###############################################################

# --[ correctly show folder structure in Visual Studio
function(assign_source_group)
  foreach(_source IN ITEMS ${ARGN})
    if (IS_ABSOLUTE "${_source}")
      file(RELATIVE_PATH _source_rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_source}")
    else()
      set(_source_rel "${_source}")
    endif()
    get_filename_component(_source_path "${_source_rel}" PATH)
    string(REPLACE "/" "\\" _source_path_msvc "${_source_path}")
    source_group("${_source_path_msvc}" FILES "${_source}")
  endforeach()
endfunction(assign_source_group)

function(overlook_add_executable)
  if (CMAKE_SYSTEM_NAME MATCHES "Windows" OR CMAKE_SYSTEM_NAME MATCHES "Darwin")
    foreach(_source IN ITEMS ${ARGN})
      assign_source_group(${_source})
    endforeach()
    #message("${ARGV}")
  endif ()
  add_executable(${ARGV})
endfunction(overlook_add_executable)

function(overlook_cuda_add_executable)
  if (CMAKE_SYSTEM_NAME MATCHES "Windows" OR CMAKE_SYSTEM_NAME MATCHES "Darwin")
    foreach(_source IN ITEMS ${ARGN})
      assign_source_group(${_source})
    endforeach()
    #message("${ARGV}")
  endif ()
  cuda_add_executable(${ARGV})
endfunction(overlook_cuda_add_executable)

function(overlook_add_library)
  if (CMAKE_SYSTEM_NAME MATCHES "Windows" OR CMAKE_SYSTEM_NAME MATCHES "Darwin")
    foreach(_source IN ITEMS ${ARGN})
      assign_source_group(${_source})
    endforeach()
    #message("${ARGV}")
  endif ()
  add_library(${ARGV})
endfunction(overlook_add_library)

function(overlook_cuda_add_library)
  if (CMAKE_SYSTEM_NAME MATCHES "Windows" OR CMAKE_SYSTEM_NAME MATCHES "Darwin")
    foreach(_source IN ITEMS ${ARGN})
      assign_source_group(${_source})
    endforeach()
    #message("${ARGV}")
  endif ()
  cuda_add_library(${ARGV})
endfunction(overlook_cuda_add_library)

# append element to list with space as seperator
function(overlook_list_append __string __element)
  # set(__list ${${__string}})
  # set(__list "${__list} ${__element}")
  # set(${__string} ${__list} PARENT_SCOPE)
  #set(__list ${${__string}})
  set(${__string} "${${__string}} ${__element}" PARENT_SCOPE)
endfunction()

option(OVERLOOK_FLAGS_GLOBAL "use safe compilation flags?" ON)
option(OVERLOOK_STRICT_FLAGS "strict c/c++ flags checking?" OFF)
option(USE_CPPCHECK "use cppcheck for static checking?" OFF)
option(OVERLOOK_VERBOSE "verbose output?" OFF)

###############################################################
#
# Important CFLAGS/CXXFLAGS
#
###############################################################

set(OVERLOOK_C_FLAGS "")
set(OVERLOOK_CXX_FLAGS "")


# 0. 检查编译器版本。同一编译器的不同版本，编译选项的支持情况可能不同。
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang" AND CLANG_VERSION_STRING)
  message(STATUS "--- CLANG_VERSION_MAJOR is: ${CLANG_VERSION_MAJOR}")
  message(STATUS "--- CLANG_VERSION_MINOR is: ${CLANG_VERSION_MINOR}")
  message(STATUS "--- CLANG_VERSION_PATCHLEVEL is: ${CLANG_VERSION_PATCHLEVEL}")
  message(STATUS "--- CLANG_VERSION_STRING is: ${CLANG_VERSION_STRING}")
endif()

if(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
  message(STATUS "--- CMAKE_CXX_COMPILER_VERSION is: ${CMAKE_CXX_COMPILER_VERSION}")
  # if(CMAKE_CXX_COMPILER_VERSION GREATER 9.1) # when >= 9.2, not support this option
  #   message(STATUS "---- DEBUG INFO HERE !!!")
  # endif()
endif()

if(CMAKE_C_COMPILER_ID)
  set(OVERLOOK_WITH_C TRUE)
else()
  set(OVERLOOK_WITH_C FALSE)
endif()

if(CMAKE_CXX_COMPILER_ID)
  set(OVERLOOK_WITH_CXX TRUE)
else()
  set(OVERLOOK_WITH_CXX FALSE)
endif()

# Project LANGUAGE not including C and CXX so we return
if((NOT OVERLOOK_WITH_C) AND (NOT OVERLOOK_WITH_CXX))
  message("OverLook WARNING: neither C nor CXX compilers available. No OVERLOOK C/C++ flags will be set")
  message("  NOTE: You many consider add C and CXX in `project()` command")
  return()
endif()

# 1. 函数没有声明就使用
# 解决bug：地址截断；内存泄漏
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS /we4013)
  overlook_list_append(OVERLOOK_CXX_FLAGS /we4013)
elseif(CMAKE_C_COMPILER_ID MATCHES "GNU")
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=implicit-function-declaration)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=implicit-function-declaration)
elseif(CMAKE_C_COMPILER_ID MATCHES "Clang")
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=implicit-function-declaration)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=implicit-function-declaration)
endif()

# 2. 函数虽然有声明，但是声明不完整，没有写出返回值类型
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS /we4431)
  overlook_list_append(OVERLOOK_CXX_FLAGS /we4431)
elseif(CMAKE_C_COMPILER_ID MATCHES "GNU")
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=implicit-int)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=implicit-int)
elseif(CMAKE_C_COMPILER_ID MATCHES "Clang")
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=implicit-int)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=implicit-int)
endif()

# 3. 指针类型不兼容
# 解决bug：crash或结果异常
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS /we4133)
  overlook_list_append(OVERLOOK_CXX_FLAGS /we4133)
elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
  if(CMAKE_CXX_COMPILER_VERSION GREATER 4.8) # gcc/g++ 4.8.3 not ok
    overlook_list_append(OVERLOOK_C_FLAGS -Werror=incompatible-pointer-types)
    overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=incompatible-pointer-types)
  endif()
elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=incompatible-pointer-types)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=incompatible-pointer-types)
endif()

# 4. 函数应该有返回值但没有return返回值;或不是所有路径都有返回值
# 解决bug：lane detect; vpdt for循环无法跳出(android输出trap)
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS /we4716 /we4715)
  overlook_list_append(OVERLOOK_CXX_FLAGS /we4716 /we4715)
else()
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=return-type)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=return-type)
endif()

# 5. 避免使用影子(shadow)变量
# 有时候会误伤，例如eigen等开源项目，可以手动关掉
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS /we6244 /we6246 /we4457 /we4456)
  overlook_list_append(OVERLOOK_CXX_FLAGS /we6244 /we6246 /we4457 /we4456)
else()
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=shadow)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=shadow)
endif()

# 6. 函数不应该返回局部变量的地址
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS /we4172)
  overlook_list_append(OVERLOOK_CXX_FLAGS /we4172)
elseif(CMAKE_C_COMPILER_ID MATCHES "GNU")
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=return-local-addr)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=return-local-addr)
elseif(CMAKE_C_COMPILER_ID MATCHES "Clang")
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=return-stack-address)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=return-stack-address)
endif()

# 7. 变量没初始化就使用，要避免
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS "/we4700 /we26495")
  overlook_list_append(OVERLOOK_CXX_FLAGS "/we4700 /we26495")
else()
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=uninitialized)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=uninitialized)
endif()

# 8. printf等语句中的格式串和实参类型不匹配，要避免
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS /we4477)
  overlook_list_append(OVERLOOK_CXX_FLAGS /we4477)
else()
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=format)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=format)
endif()

# 9. 避免把unsigned int和int直接比较
# 通常会误伤，例如for循环中。可以考虑关掉
if(OVERLOOK_STRICT_FLAGS)
  if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
    overlook_list_append(OVERLOOK_C_FLAGS /we4018)
    overlook_list_append(OVERLOOK_CXX_FLAGS /we4018)
  elseif(CMAKE_C_COMPILER_ID MATCHES "GNU")
    overlook_list_append(OVERLOOK_C_FLAGS -Werror=sign-compare)
    overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=sign-compare)
  elseif(CMAKE_C_COMPILER_ID MATCHES "Clang")
    overlook_list_append(OVERLOOK_C_FLAGS -Werror=sign-compare)
    overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=sign-compare)
  endif()
endif()

# 10. 避免把int指针赋值给int类型变量
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS /we4047)
  overlook_list_append(OVERLOOK_CXX_FLAGS /we4047)
elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
  if(CMAKE_CXX_COMPILER_VERSION GREATER 4.8)
    overlook_list_append(OVERLOOK_C_FLAGS -Werror=int-conversion)
    overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=int-conversion)
  endif()
elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=int-conversion)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=int-conversion)
endif()

# 11. 检查数组下标越界访问
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS "/we6201 /we6386 /we4789")
  overlook_list_append(OVERLOOK_CXX_FLAGS "/we6201 /we6386 /we4789")
else()
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=array-bounds)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=array-bounds)
endif()

# 12. 函数声明中的参数列表和定义中不一样。在MSVC C下为警告，Linux Clang下报错
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS /we4029)
endif()

# 13. 实参太多，比函数定义或声明中的要多。只在纯MSVC C下为警告，Linux Clang下报错
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS /we4020)
endif()

# 14. 避免void*类型的指针参参与算术运算
# MSVC C/C++默认会报错，Linux gcc不报warning和error，Linux g++只报warning
# Linux下 Clang开-Wpedentric才报warning，Clang++报error
if(CMAKE_C_COMPILER_ID MATCHES "GNU")
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=pointer-arith)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=pointer-arith)
elseif(CMAKE_C_COMPILER_ID MATCHES "Clang")
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=pointer-arith)
endif()

# 15. 避免符号重复定义（变量对应的强弱符号）。只在纯C下出现。
# 暂时没找到MSVC的对应编译选项
if(CMAKE_C_COMPILER_ID MATCHES "GNU" OR CMAKE_C_COMPILER_ID MATCHES "Clang")
  overlook_list_append(OVERLOOK_C_FLAGS -fno-common)
endif()

# 16. Windows下，源码已经是UTF-8编码，但输出中文到stdout时
# 要么编译报错，要么乱码。解决办法是编译输出为GBK格式
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS "/source-charset:utf-8 /execution-charset:gbk")
  overlook_list_append(OVERLOOK_CXX_FLAGS "/source-charset:utf-8 /execution-charset:gbk")
endif()

# 17. 释放非堆内存
# TODO: 检查MSVC
# Linux Clang8.0无法检测到
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=free-nonheap-object)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=free-nonheap-object)
endif()

# 18. 形参与声明不同。场景：静态库(.h/.c)，集成时换库但没换头文件，且函数形参有变化（类型或数量）
# 只报warning不报error。仅VS出现
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS /we4028)
endif()

# 19. 宏定义重复
# gcc5~gcc9无法检查
if (0)
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS /we4005)
  overlook_list_append(OVERLOOK_CXX_FLAGS /we4005)
elseif(CMAKE_C_COMPILER_ID MATCHES "Clang")
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=macro-redefined)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=macro-redefined)
endif()
endif()

# 20. pragma init_seg指定了非法（不能识别的）section名字
# VC++特有。Linux下的gcc/clang没有
if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_CXX_FLAGS /we4075)
endif()

# 21. size_t类型被转为更窄类型
# VC/VC++特有。Linux下的gcc/clang没有
# 有点过于严格了
if (OVERLOOK_STRICT_FLAGS)
  if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
    overlook_list_append(OVERLOOK_C_FLAGS /we4267)
    overlook_list_append(OVERLOOK_CXX_FLAGS /we4267)
  endif()
endif()

# 22. “类型强制转换”: 例如从“int”转换到更大的“void *”
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS /we4312)
  overlook_list_append(OVERLOOK_CXX_FLAGS /we4312)
elseif(CMAKE_C_COMPILER_ID MATCHES "GNU")
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=int-to-pointer-cast)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=int-to-pointer-cast)
elseif(CMAKE_C_COMPILER_ID MATCHES "Clang")
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=int-to-pointer-cast)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=int-to-pointer-cast)
endif()

# 23. 不可识别的字符转义序列
# GCC5.4能显示warning但无别名，因而无法视为error
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS /we4129)
  overlook_list_append(OVERLOOK_CXX_FLAGS /we4129)
elseif(CMAKE_C_COMPILER_ID MATCHES "Clang")
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=unknown-escape-sequence)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=unknown-escape-sequence)
endif()

# 24. 类函数宏的调用 参数过多
# VC/VC++报警告。Linux下的GCC/Clang报error
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS /we4002)
  overlook_list_append(OVERLOOK_CXX_FLAGS /we4002)
endif()

# 25. 类函数宏的调用 参数不足
# VC/VC++同时会报error C2059
# Linux GCC/Clang直接报错
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS /we4003)
  overlook_list_append(OVERLOOK_CXX_FLAGS /we4003)
endif()

# 26. #undef没有跟一个标识符
# Linux GCC/Clang直接报错
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS /we4006)
  overlook_list_append(OVERLOOK_CXX_FLAGS /we4006)
endif()

# 27. 单行注释包含行继续符
# 可能会导致下一行代码报错，而问题根源在包含继续符的这行注释
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS /we4006)
  overlook_list_append(OVERLOOK_CXX_FLAGS /we4006)
elseif(CMAKE_C_COMPILER_ID MATCHES "GNU")
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=comment)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=comment)
elseif(CMAKE_C_COMPILER_ID MATCHES "Clang")
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=comment)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=comment)
endif()

# 28. 没有使用到表达式结果（无用代码行，应删除）
# 感觉容易被误伤，可以考虑关掉
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS "/we4552 /we4555")
  overlook_list_append(OVERLOOK_CXX_FLAGS "/we4552 /we4555")
elseif(CMAKE_C_COMPILER_ID MATCHES "GNU")
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=unused-value)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=unused-value)
elseif(CMAKE_C_COMPILER_ID MATCHES "Clang")
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=unused-value)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=unused-value)
endif()

# 29. “==”: 未使用表达式结果；是否打算使用“=”?
# Linux GCC 没有对应的编译选项
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS /we4553)
  overlook_list_append(OVERLOOK_CXX_FLAGS /we4553)
elseif(CMAKE_C_COMPILER_ID MATCHES "Clang")
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=unused-comparison)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=unused-comparison)
endif()

# 30. C++中，禁止把字符串常量赋值给char*变量
# VS2019开启/Wall后也查不到
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=write-strings)
elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  # Linux Clang 和 AppleClang 不太一样
  if (CMAKE_SYSTEM_NAME MATCHES "Linux")
    overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=writable-strings)
  elseif(CMAKE_SYSTEM_NAME MATCHES "Darwin")
    overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=c++11-compat-deprecated-writable-strings)
  endif()
endif()

# 31. 所有的控件路径(if/else)必须都有返回值
# NDK21 Clang / Linux Clang/GCC/G++ 默认都报 error
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  overlook_list_append(OVERLOOK_C_FLAGS /we4715)
  overlook_list_append(OVERLOOK_CXX_FLAGS /we4715)
endif()

# 32. multi-char constant
# MSVC 没有对应的选项
if(CMAKE_C_COMPILER_ID MATCHES "GNU")
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=multichar)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=multichar)
elseif(CMAKE_C_COMPILER_ID MATCHES "Clang")
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=multichar)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=multichar)
endif()

# 33. 用 memset 等 C 函数设置 非POD class 对象
# linux下，GCC9.3能发现此问题，但clang10不能发现
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=class-memaccess)
endif()

## 34. 括号里面是单个等号而不是双等号
# linux下， Clang14 可以发现问题，但GCC9.3无法发现；android clang可以发现
if(CMAKE_C_COMPILER_ID MATCHES "Clang")
  overlook_list_append(OVERLOOK_C_FLAGS -Werror=parentheses)
  overlook_list_append(OVERLOOK_CXX_FLAGS -Werror=parentheses)
endif()


# 将上述定制的FLAGS追加到CMAKE默认的编译选项中
# 为什么是添加而不是直接设定呢？因为toolchain（比如android的）会加料
if (OVERLOOK_FLAGS_GLOBAL)
  overlook_list_append(CMAKE_C_FLAGS "${OVERLOOK_C_FLAGS}")
  overlook_list_append(CMAKE_CXX_FLAGS "${OVERLOOK_CXX_FLAGS}")

  overlook_list_append(CMAKE_C_FLAGS_DEBUG "${OVERLOOK_C_FLAGS}")
  overlook_list_append(CMAKE_CXX_FLAGS_DEBUG "${OVERLOOK_CXX_FLAGS}")

  overlook_list_append(CMAKE_C_FLAGS_RELEASE "${OVERLOOK_C_FLAGS}")
  overlook_list_append(CMAKE_CXX_FLAGS_RELEASE "${OVERLOOK_CXX_FLAGS}")

  overlook_list_append(CMAKE_C_FLAGS_MINSIZEREL "${OVERLOOK_C_FLAGS}")
  overlook_list_append(CMAKE_CXX_FLAGS_MINSIZEREL "${OVERLOOK_CXX_FLAGS}")

  overlook_list_append(CMAKE_C_FLAGS_RELWITHDEBINFO "${OVERLOOK_C_FLAGS}")
  overlook_list_append(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${OVERLOOK_CXX_FLAGS}")
endif()

if (OVERLOOK_VERBOSE)
  message(STATUS "--- OVERLOOK_C_FLAGS are: ${OVERLOOK_C_FLAGS}")
  message(STATUS "--- OVERLOOK_CXX_FLAGS are: ${OVERLOOK_CXX_FLAGS}")
endif()


##################################################################################
# Add whole archive when build static library
# Usage:
#   overlook_add_whole_archive_flag(<lib> <output_var>)
# Example:
#   add_library(foo foo.hpp foo.cpp)
#   add_executable(bar bar.cpp)
#   overlook_add_whole_archive_flag(foo safe_foo)
#   target_link_libraries(bar ${safe_foo})
##################################################################################
function(overlook_add_whole_archive_flag lib output_var)
  if("${CMAKE_CXX_COMPILER_ID}" MATCHES "MSVC")
    if(MSVC_VERSION GREATER 1900)
      set(${output_var} -WHOLEARCHIVE:$<TARGET_FILE:${lib}> PARENT_SCOPE)
    else()
      message(WARNING "MSVC version is ${MSVC_VERSION}, /WHOLEARCHIVE flag cannot be set")
      set(${output_var} ${lib} PARENT_SCOPE)
    endif()
  elseif("${CMAKE_CXX_COMPILER_ID}" MATCHES "GNU")
    set(${output_var} -Wl,--whole-archive ${lib} -Wl,--no-whole-archive PARENT_SCOPE)
  elseif("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang" AND CMAKE_SYSTEM_NAME MATCHES "Linux")
    set(${output_var} -Wl,--whole-archive ${lib} -Wl,--no-whole-archive PARENT_SCOPE)
  elseif ("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang" AND NOT ANDROID)
    set(${output_var} -Wl,-force_load ${lib} PARENT_SCOPE)
  elseif(ANDROID)
    #即使是NDK21并且手动传入ANDROID_LD=lld，依然要用ld的查重复符号的链接选项
    set(${output_var} -Wl,--whole-archive ${lib} -Wl,--no-whole-archive PARENT_SCOPE)
  else()
    message(FATAL_ERROR ">>> add_whole_archive_flag not supported yet for current compiler: ${CMAKE_CXX_COMPILER_ID}")
  endif()
endfunction()


###############################################################
#
# cppcheck，开启静态代码检查，主要是检查编译器检测不到的UB
#   注: 目前只有终端下能看到对应输出，其中NDK下仅第一次输出
#
###############################################################
if(USE_CPPCHECK)
  find_program(CMAKE_CXX_CPPCHECK NAMES cppcheck)
  if (CMAKE_CXX_CPPCHECK)
    message(STATUS "cppcheck found")
    list(APPEND CMAKE_CXX_CPPCHECK
      "--enable=warning"
      "--inconclusive"
      "--force"
      "--inline-suppr"
    )
  else()
    message(STATUS "cppcheck not found. ignore it")
  endif()
endif()


###############################################################
#
# Platform determinations
#
###############################################################
if (CMAKE_SYSTEM_NAME MATCHES "Windows")
  set(OVERLOOK_SYSTEM "Windows")
elseif (ANDROID)
  set(OVERLOOK_SYSTEM "Android")
elseif (CMAKE_SYSTEM_NAME MATCHES "Linux")
  set(OVERLOOK_SYSTEM "Linux")
elseif (CMAKE_SYSTEM_NAME MATCHES "Darwin")
  set(OVERLOOK_SYSTEM "MacOS")
else ()
  message(FATAL_ERROR "un-configured system: ${CMAKE_SYSTEM_NAME}")
endif()
if (OVERLOOK_VERBOSE)
  message(STATUS "----- OVERLOOK_SYSTEM: ${OVERLOOK_SYSTEM}")
endif()

###############################################################
#
# Architecture determinations
#
###############################################################
if((IOS AND CMAKE_OSX_ARCHITECTURES MATCHES "arm") #没匹配ARM
  OR (CMAKE_SYSTEM_PROCESSOR MATCHES "^(arm|Arm|ARM|aarch64|AAarch64|AARCH64)"))
  set(OVERLOOK_ARCH arm)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "^(mips|Mips|MIPS)")
  set(OVERLOOK_ARCH mips)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "^(riscv|Riscv|RISCV)")
  set(OVERLOOK_ARCH riscv)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "^(powerpc|PowerPC|POWERPC)")
  set(OVERLOOK_ARCH powerpc)
else()
  set(OVERLOOK_ARCH x86)
  #if(CMAKE_SYSTEM_NAME STREQUAL "Emscripten") #wasm
  #endif()
endif()
if (OVERLOOK_VERBOSE)
  message(STATUS "----- OVERLOOK_ARCH: ${OVERLOOK_ARCH}")
endif()

###############################################################
#
# ABI determinations
#
###############################################################
if (ANDROID)
  set(OVERLOOK_ABI ${ANDROID_ABI})
elseif (OVERLOOK_ARCH STREQUAL x86)
  if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(OVERLOOK_ABI "x64")
  else()
    set(OVERLOOK_ABI "x86")
  endif()
elseif (OVERLOOK_ARCH STREQUAL arm)
  # determine ARCH from compiler name. Note: we can't use MATCHES for c++ compiler, since `++` failed for regular expression
  if(CMAKE_C_COMPILER MATCHES "aarch64-linux-gnu-gcc")
    set(OVERLOOK_ABI "aarch64")
  elseif(CMAKE_C_COMPILER MATCHES "arm-linux-gnueabihf-gcc")
    set(OVERLOOK_ABI "arm-eabihf")
  elseif(CMAKE_C_COMPILER MATCHES "aarch64-none-linux-gnu-gcc")
    set(OVERLOOK_ABI "aarch64")
  elseif(NOT CMAKE_CROSS_COMPILATION)
    if(CMAKE_SYSTEM_NAME MATCHES "Darwin")
      set(OVERLOOK_ABI "aarch64")
    else()
      message(FATAL_ERROR "un-assigned ABI, please add it now")
    endif()
  else()
    message(FATAL_ERROR "un-assigned ABI, please add it now")
  endif()
else()
  message(FATAL_ERROR "un-assigned ABI, please add it now")
endif()
if (OVERLOOK_VERBOSE)
  message(STATUS "----- OVERLOOK_ABI: ${OVERLOOK_ABI}")
endif()

###############################################################
#
# Visual Studio stuffs: vs_version, vc_version
#
###############################################################
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  if(MSVC_VERSION EQUAL 1600)
    set(vs_version vs2010)
    set(vc_version vc10)
  elseif(MSVC_VERSION EQUAL 1700)
    set(vs_version vs2012)
    set(vc_version vc11)
  elseif(MSVC_VERSION EQUAL 1800)
    set(vs_version vs2013)
    set(vc_version vc12)
  elseif(MSVC_VERSION EQUAL 1900)
    set(vs_version vs2015)
    set(vc_version vc14)
  elseif(MSVC_VERSION GREATER_EQUAL 1910 AND MSVC_VERSION LESS_EQUAL 1920)
    set(vs_version vs2017)
    set(vc_version vc15)
  elseif(MSVC_VERSION GREATER_EQUAL 1920 AND MSVC_VERSION LESS_EQUAL 1930)
    set(vs_version vs2019)
    set(vc_version vc16)
  elseif(MSVC_VERSION GREATER_EQUAL 1930)
    set(vs_version vs2022)
    set(vc_version vc17)
  endif()
endif()

