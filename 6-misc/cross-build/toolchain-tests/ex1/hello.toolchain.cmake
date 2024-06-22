### begin of include guard
if(HELLO_TOOLCHAIN_INCLUDED)
  return()
endif()
set(HELLO_TOOLCHAIN_INCLUDED TRUE)
### end of include guard

message("[debug] calling toolchain file: ${CMAKE_CURRENT_LIST_FILE} ${CMAKE_TOOLCHAIN_FILE}")

set(CMAKE_SYSTEM_NAME Darwin)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR arm64)

list(APPEND ANDROID_COMPILER_FLAGS
  -g
  -DANDROID
  -fdata-sections
  -ffunction-sections
  -funwind-tables
  -fstack-protector-strong
  -no-canonical-prefixes)

string(REPLACE ";" " " ANDROID_COMPILER_FLAGS         "${ANDROID_COMPILER_FLAGS}")

set(CMAKE_C_FLAGS ""
  CACHE STRING "Flags used by the compiler during all build types.")

set(CMAKE_C_FLAGS             "${ANDROID_COMPILER_FLAGS} ${CMAKE_C_FLAGS}")
