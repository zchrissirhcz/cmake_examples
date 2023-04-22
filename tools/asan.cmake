# last update: 2023/04/22

option(USE_ASAN "Use Address Sanitizer?" ON)

#--------------------------------------------------
# globally
#--------------------------------------------------
# https://stackoverflow.com/a/65019152/2999096
# https://docs.microsoft.com/en-us/cpp/build/cmake-presets-vs?view=msvc-170#enable-addresssanitizer-for-windows-and-linux
if(USE_ASAN)
  if((CMAKE_C_COMPILER_ID STREQUAL "MSVC") OR (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC"))
    set(ASAN_OPTIONS "/fsanitize=address")
  elseif(MSVC AND ((CMAKE_C_COMPILER_ID STREQUAL "Clang") OR (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")))
    message(FATAL_ERROR "Clang-CL not support setup AddressSanitizer via CMakeLists.txt")
  elseif((CMAKE_C_COMPILER_ID MATCHES "GNU") OR (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    OR (CMAKE_C_COMPILER_ID MATCHES "Clang") OR (CMAKE_CXX_COMPILER_ID MATCHES "Clang"))
    set(ASAN_OPTIONS -fsanitize=address -fno-omit-frame-pointer -g)
  endif()
  message(STATUS ">>> USE_ASAN: YES")
  message(STATUS ">>> CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
  add_compile_options(${ASAN_OPTIONS})
  if(CMAKE_SYSTEM_NAME MATCHES "Windows")
    add_link_options("/ignore:4300") # /INCREMENTAL
  else()
    add_link_options(${ASAN_OPTIONS})
  endif()
else()
  message(STATUS ">>> USE_ASAN: NO")
endif()


#--------------------------------------------------
# per-target
#--------------------------------------------------
# https://developer.android.com/ndk/guides/asan?hl=zh-cn#cmake
#target_compile_options(${TARGET} PUBLIC -fsanitize=address -fno-omit-frame-pointer)
#set_target_properties(${TARGET} PROPERTIES LINK_FLAGS -fsanitize=address)
