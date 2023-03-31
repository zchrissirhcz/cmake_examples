###############################################################
#
# cvbuild: cmake plugin for buildenv determination
#
# Author:   Zhuo Zhang <imzhuo@foxmail.com>
# Homepage: https://github.com/cvpkg/cvbuild
#
###############################################################

cmake_minimum_required(VERSION 3.1)

# Only included once
if(CVBUILD_INCLUDE_GUARD)
  return()
endif()
set(CVBUILD_INCLUDE_GUARD TRUE)

set(CVBUILD_VERSION "2023.03.31")

###############################################################
#
# Platform determinations
#
###############################################################
if(CMAKE_SYSTEM_NAME MATCHES "Windows")
  set(CVBUILD_PLATFORM "windows")
elseif(ANDROID)
  set(CVBUILD_PLATFORM "android")
elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
  set(CVBUILD_PLATFORM "linux")
elseif(CMAKE_SYSTEM_NAME MATCHES "Darwin")
  set(CVBUILD_PLATFORM "mac")
else()
  message(FATAL_ERROR "un-configured platform: ${CMAKE_SYSTEM_NAME}")
endif()
if(CVBUILD_VERBOSE)
  message(STATUS "----- CVBUILD_PLATFORM: ${CVBUILD_PLATFORM}")
endif()

###############################################################
#
# Architecture determinations
#
###############################################################
if((IOS AND CMAKE_OSX_ARCHITECTURES MATCHES "arm")
  OR (CMAKE_SYSTEM_PROCESSOR MATCHES "^(arm|Arm|ARM|aarch64|AAarch64|AARCH64)"))
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
      set(CVBUILD_ARCH arm64)
    else()
      set(CVBUILD_ARCH arm32)
    endif()
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "^(mips|Mips|MIPS)")
  set(CVBUILD_ARCH mips)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "^(riscv|Riscv|RISCV)")
  set(CVBUILD_ARCH riscv)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "^(powerpc|PowerPC|POWERPC)")
  set(CVBUILD_ARCH powerpc)
else()
  set(CVBUILD_ARCH x86)
  #if(CMAKE_SYSTEM_NAME STREQUAL "Emscripten") #wasm
  #endif()
endif()
if (CVBUILD_VERBOSE)
  message(STATUS "----- CVBUILD_ARCH: ${CVBUILD_ARCH}")
endif()

###############################################################
#
# ABI determinations
#
###############################################################
if (ANDROID)
  set(CVBUILD_ABI ${ANDROID_ABI})
elseif(CVBUILD_ARCH STREQUAL x86)
  if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(CVBUILD_ABI "x64")
  else()
    set(CVBUILD_ABI "x86")
  endif()
elseif(CVBUILD_ARCH MATCHES arm)
  # determine ARCH from compiler name. Note: we can't use MATCHES for c++ compiler, since `++` failed for regular expression
  if(CMAKE_C_COMPILER MATCHES "aarch64-linux-gnu-gcc")
    set(CVBUILD_ABI "aarch64")
  elseif(CMAKE_C_COMPILER MATCHES "arm-linux-gnueabihf-gcc")
    set(CVBUILD_ABI "arm-eabihf")
  elseif(CMAKE_C_COMPILER MATCHES "aarch64-none-linux-gnu-gcc")
    set(CVBUILD_ABI "aarch64")
  elseif(NOT CMAKE_CROSS_COMPILATION)
    if(CMAKE_SYSTEM_NAME MATCHES "Darwin")
      set(CVBUILD_ABI "aarch64")
    else()
      message(FATAL_ERROR "un-assigned ABI, please add it now")
    endif()
  else()
    message(FATAL_ERROR "un-assigned ABI, please add it now")
  endif()
else()
  message(FATAL_ERROR "un-assigned ABI, please add it now")
endif()
if (CVBUILD_VERBOSE)
  message(STATUS "----- CVBUILD_ABI: ${CVBUILD_ABI}")
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
