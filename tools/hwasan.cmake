# last update: 2023/01/16

option(USE_HWASAN "Use Hardware-assisted Address Sanitizer?" ON)
#--------------------------------------------------
# globally setting
#--------------------------------------------------
# https://developer.android.google.cn/ndk/guides/hwasan#ndk-build
if(USE_HWASAN)
  if(ANDROID)
    # Note: `-g` is explicitly required here for debug symbol information such line number and file name
    # There is NDK's android.toolchain.cmake's `-g`, in case user removed it, explicitly add `-g` here.
    set(HWASAN_FLAGS "-g -fsanitize=hwaddress -fno-omit-frame-pointer")
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
  message(STATUS ">>> CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
  if(CMAKE_BUILD_TYPE MATCHES "Debug")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} ${HWASAN_FLAGS}")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} ${HWASAN_FLAGS}")
    set(CMAKE_LINKER_FLAGS_DEBUG "${CMAKE_LINKER_FLAGS_DEBUG} ${HWASAN_FLAGS}")
  elseif(CMAKE_BUILD_TYPE MATCHES "Release")
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} ${HWASAN_FLAGS}")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} ${HWASAN_FLAGS}")
    set(CMAKE_LINKER_FLAGS_RELEASE "${CMAKE_LINKER_FLAGS_RELEASE} ${HWASAN_FLAGS}")
  elseif(CMAKE_BUILD_TYPE MATCHES "RelWithDebInfo")
    set(CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO} ${HWASAN_FLAGS}")
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} ${HWASAN_FLAGS}")
    set(CMAKE_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_LINKER_FLAGS_RELWITHDEBINFO} ${HWASAN_FLAGS}")
  elseif(CMAKE_BUILD_TYPE MATCHES "MinSizeRel")
    set(CMAKE_C_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL} ${HWASAN_FLAGS}")
    set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} ${HWASAN_FLAGS}")
    set(CMAKE_LINKER_FLAGS_MINSIZEREL "${CMAKE_LINKER_FLAGS_MINSIZEREL} ${HWASAN_FLAGS}")
  elseif(CMAKE_BUILD_TYPE EQUAL "None" OR NOT CMAKE_BUILD_TYPE)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${HWASAN_FLAGS}")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${HWASAN_FLAGS}")
    set(CMAKE_LINKER_FLAGS "${CMAKE_LINKER_FLAGS} ${HWASAN_FLAGS}")
  else()
    message(FATAL_ERROR "Unsupported CMAKE_BUILD_TYPE for HWAsan setup: ${CMAKE_BUILD_TYPE}. Supported: Debug, Release, RelWithDebInfo, MinSizeRel")
  endif()
else()
  message(STATUS ">>> USE_HWASAN: NO")
endif()
