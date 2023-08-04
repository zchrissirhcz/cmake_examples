# Author: Zhuo Zhang <imzhuo@foxmail.com>
# Homepage: https://github.com/zchrissirhcz
# Last update: 2023-08-04 23:55:28

option(VS2022_ASAN_DISABLE_VECTOR_ANNOTATION "Disable string annotation for VS2022 ASan?" ON)
option(VS2022_ASAN_DISABLE_STRING_ANNOTATION "Disable vector annotation for VS2022 ASan?" ON)

# globally
# https://stackoverflow.com/a/65019152/2999096
# https://docs.microsoft.com/en-us/cpp/build/cmake-presets-vs?view=msvc-170#enable-addresssanitizer-for-windows-and-linux
set(ASAN_AVAILABLE ON)
if((CMAKE_C_COMPILER_ID STREQUAL "MSVC") OR (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC"))
  if((CMAKE_C_COMPILER_VERSION STRLESS 16.0) OR (CMAKE_CXX_COMPILER_VERSION STRLESS 16.0))
    message(WARNING "ASAN is available since VS2019, please use higher version of VS")
    set(ASAN_AVAILABLE OFF)
  elseif( ((CMAKE_C_COMPILER_VERSION STRGREATER_EQUAL 16.0) AND (CMAKE_C_COMPILER_VERSION STRLESS 16.7))
    OR ((CMAKE_CXX_COMPILER_VERSION STRGREATER_EQUAL 16.0) AND (CMAKE_CXX_COMPILER_VERSION STRLESS 16.7)) )
    # https://devblogs.microsoft.com/cppblog/asan-for-windows-x64-and-debug-build-support/
    message(WARNING "VS2019 x64 ASAN requires VS >= 16.7, please update VS")
    set(ASAN_AVAILABLE OFF)
  else()
    set(ASAN_OPTIONS /fsanitize=address)
  endif()
elseif(MSVC AND ((CMAKE_C_COMPILER_ID STREQUAL "Clang") OR (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")))
  message(WARNING "Clang-CL not support setup AddressSanitizer via CMakeLists.txt")
  set(ASAN_AVAILABLE OFF)
elseif((CMAKE_C_COMPILER_ID MATCHES "GNU") OR (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  OR (CMAKE_C_COMPILER_ID MATCHES "Clang") OR (CMAKE_CXX_COMPILER_ID MATCHES "Clang"))
  set(ASAN_OPTIONS -fsanitize=address -fno-omit-frame-pointer -g)
endif()

if(ASAN_AVAILABLE)
  message(STATUS ">>> USE_ASAN: YES")
  add_compile_options(${ASAN_OPTIONS})
  if((CMAKE_SYSTEM_NAME MATCHES "Windows") AND ((CMAKE_C_COMPILER_ID STREQUAL "MSVC") OR (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")))
    add_link_options(/ignore:4300) # /INCREMENTAL
    add_link_options(/DEBUG) # LNK4302

    if(CMAKE_CXX_COMPILER_VERSION STRGREATER_EQUAL 17.2)
      if(VS2022_ASAN_DISABLE_VECTOR_ANNOTATION)
        # https://learn.microsoft.com/en-us/cpp/sanitizers/error-container-overflow?view=msvc-170
        add_definitions(-D_DISABLE_VECTOR_ANNOTATION)
        message(STATUS ">>> VS2022_ASAN_DISABLE_VECTOR_ANNOTATION: YES")
      else()
        message(STATUS ">>> VS2022_ASAN_DISABLE_VECTOR_ANNOTATION: NO")
      endif()
    endif()

    if(CMAKE_CXX_COMPILER_VERSION STRGREATER_EQUAL 17.6)
      if(VS2022_ASAN_DISABLE_STRING_ANNOTATION)
        # https://learn.microsoft.com/en-us/cpp/sanitizers/error-container-overflow?view=msvc-170
        add_definitions(-D_DISABLE_STRING_ANNOTATION)
        message(STATUS ">>> VS2022_ASAN_DISABLE_STRING_ANNOTATION: YES")
      else()
        message(STATUS ">>> VS2022_ASAN_DISABLE_STRING_ANNOTATION: NO")
      endif()
    endif()

  else()
    add_link_options(${ASAN_OPTIONS})
  endif()
else()
  message(STATUS ">>> USE_ASAN: NO")
endif()


# per-target
# https://developer.android.com/ndk/guides/asan?hl=zh-cn#cmake
# target_compile_options(${TARGET} PUBLIC -fsanitize=address -fno-omit-frame-pointer)
# set_target_properties(${TARGET} PROPERTIES LINK_FLAGS -fsanitize=address) # not working for INTERFACE targets
# target_link_options(${TARGET} INTERFACE -fsanitize=address) # for INTERFACE targets
