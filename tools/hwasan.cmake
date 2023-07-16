# Author: Zhuo Zhang <imzhuo@foxmail.com>
# Homepage: https://github.com/zchrissirhcz
# Last update: 2023-07-16 14:34:30

option(USE_HWASAN "Use Hardware-assisted Address Sanitizer?" ON)
#--------------------------------------------------
# globally setting
#--------------------------------------------------
# https://developer.android.google.cn/ndk/guides/hwasan#ndk-build
if(USE_HWASAN)
  if(ANDROID)
    # Note: `-g` is explicitly required here for debug symbol information such line number and file name
    # There is NDK's android.toolchain.cmake's `-g`, in case user removed it, explicitly add `-g` here.
    set(HWASAN_OPTIONS -fsanitize=hwaddress -fno-omit-frame-pointer -g)
  else()
    message(FATAL_ERROR "HWASan is only supported for Android")
  endif()

  # 1. NDK 21
  message(STATUS "CMAKE_CXX_COMPILER_ID: ${CMAKE_CXX_COMPILER_ID}") # Clang
  if((CMAKE_CXX_COMPILER_ID STREQUAL "Clang") AND (CMAKE_CXX_COMPILER_VERSION GREATER_EQUAL 9.0))
    #message(STATUS "CMAKE_CXX_COMPILER_VERSION: ${CMAKE_CXX_COMPILER_VERSION}") # NDK21e: 9.0
    #message(STATUS "CMAKE_CXX_COMPILER_VERSION: ${CMAKE_CXX_COMPILER_VERSION}") # NDK18b: 7.0
    message(STATUS "HWASan check: NDK version OK")
  else()
    message(FATAL_ERROR "HWSAsan check failed: requires NDK >= r21")
  endif()

  # 2. API
  if(ANDROID_NATIVE_API_LEVEL LESS 29)
    message(FATAL_ERROR "HWASan check failed: requires ANDROID_NATIVE_API_LEVEL >= 29")
  else()
    message(STATUS "HWASan check: ANDROID_NATIVE_API_LEVEL OK")
  endif()

  # 3. arm64
  if(ANDROID_ABI MATCHES "arm64-v8a")
    message(STATUS "HWASan check: ANDROID_ABI OK")
  else()
    message(FATAL_ERROR "HWASan only works for ANDROID_ABI=armv8-a")
  endif()

  message(STATUS ">>> USE_HWASAN: YES")
  add_compile_options(${HWASAN_OPTIONS})
  add_link_options(${HWASAN_OPTIONS})
else()
  message(STATUS ">>> USE_HWASAN: NO")
endif()
