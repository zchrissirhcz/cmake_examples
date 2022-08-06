# last update: 2022/05/02

option(USE_TSAN "Use Address Sanitizer?" ON)
#--------------------------------------------------
# globally setting
#--------------------------------------------------
# https://stackoverflow.com/a/65019152/2999096
# https://docs.microsoft.com/en-us/cpp/build/cmake-presets-vs?view=msvc-170#enable-addresssanitizer-for-windows-and-linux
if(USE_TSAN)
  if((CMAKE_C_COMPILER_ID STREQUAL "MSVC") OR (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        OR ((MSVC AND ((CMAKE_C_COMPILER_ID STREQUAL "Clang") OR (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")))))
      message(FATAL_ERROR "Neither MSVC nor Clang-CL support thread sanitizer")
  elseif((CMAKE_C_COMPILER_ID MATCHES "GNU") OR (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
      OR (CMAKE_C_COMPILER_ID MATCHES "Clang") OR (CMAKE_CXX_COMPILER_ID MATCHES "Clang"))
    # Note: `-g` is explicitly required here for debug symbol information such line number and file name
    # There is NDK's android.toolchain.cmake's `-g`, in case user removed it, explicitly add `-g` here.
    set(TSAN_FLAGS "-g -fno-omit-frame-pointer -fsanitize=thread")
  endif()
  
  message(STATUS ">>> USE_TSAN: YES")
  message(STATUS ">>> CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
  if(CMAKE_BUILD_TYPE MATCHES "Debug")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} ${TSAN_FLAGS}")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} ${TSAN_FLAGS}")
    set(CMAKE_LINKER_FLAGS_DEBUG "${CMAKE_LINKER_FLAGS_DEBUG} ${TSAN_FLAGS}")
  elseif(CMAKE_BUILD_TYPE MATCHES "Release")
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} ${TSAN_FLAGS}")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} ${TSAN_FLAGS}")
    set(CMAKE_LINKER_FLAGS_RELEASE "${CMAKE_LINKER_FLAGS_RELEASE} ${TSAN_FLAGS}")
  elseif(CMAKE_BUILD_TYPE MATCHES "RelWithDebInfo")
    set(CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO} ${TSAN_FLAGS}")
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} ${TSAN_FLAGS}")
    set(CMAKE_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_LINKER_FLAGS_RELWITHDEBINFO} ${TSAN_FLAGS}")
  elseif(CMAKE_BUILD_TYPE MATCHES "MinSizeRel")
    set(CMAKE_C_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL} ${TSAN_FLAGS}")
    set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} ${TSAN_FLAGS}")
    set(CMAKE_LINKER_FLAGS_MINSIZEREL "${CMAKE_LINKER_FLAGS_MINSIZEREL} ${TSAN_FLAGS}")
  elseif(CMAKE_BUILD_TYPE EQUAL "None" OR NOT CMAKE_BUILD_TYPE)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${TSAN_FLAGS}")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${TSAN_FLAGS}")
    set(CMAKE_LINKER_FLAGS "${CMAKE_LINKER_FLAGS} ${TSAN_FLAGS}")
  else()
    message(FATAL_ERROR "Unsupported CMAKE_BUILD_TYPE for asan setup: ${CMAKE_BUILD_TYPE}")
  endif()
else()
  message(STATUS ">>> USE_TSAN: NO")
endif()
