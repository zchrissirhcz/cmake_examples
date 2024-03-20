if(HELLO_TOOLCHAIN_INCLUDED)
  return()
endif()
set(HELLO_TOOLCHAIN_INCLUDED TRUE)

message("[debug] calling toolchain file: ${CMAKE_CURRENT_LIST_FILE} ${CMAKE_TOOLCHAIN_FILE}")

set(CMAKE_SYSTEM_NAME Darwin)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR arm64)

list(APPEND ANDROID_COMPILER_FLAGS -fdata-sections)

string(REPLACE ";" " " ANDROID_COMPILER_FLAGS         "${ANDROID_COMPILER_FLAGS}")

set(CMAKE_CXX_FLAGS ""
  CACHE STRING "Flags used by the compiler during all build types.")

set(CMAKE_CXX_FLAGS             "${ANDROID_COMPILER_FLAGS} ${CMAKE_CXX_FLAGS}")
