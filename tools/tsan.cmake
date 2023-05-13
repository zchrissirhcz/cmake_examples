# Author: ChrisZZ <imzhuo@foxmail.com>
# Homepage: https://github.com/zchrissirhcz
# Last update: 2023-05-14 00:23:00

option(USE_TSAN "Use Thread Sanitizer?" ON)

# globally
if(USE_TSAN)
  if((CMAKE_C_COMPILER_ID STREQUAL "MSVC") OR (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        OR ((MSVC AND ((CMAKE_C_COMPILER_ID STREQUAL "Clang") OR (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")))))
      message(FATAL_ERROR "Neither MSVC nor Clang-CL support thread sanitizer")
  elseif((CMAKE_C_COMPILER_ID MATCHES "GNU") OR (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
      OR (CMAKE_C_COMPILER_ID MATCHES "Clang") OR (CMAKE_CXX_COMPILER_ID MATCHES "Clang"))
    set(TSAN_OPTIONS -fsanitize=thread -fno-omit-frame-pointer -g)
  endif()
  message(STATUS ">>> USE_TSAN: YES")
  message(STATUS ">>> CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
  add_compile_options(${TSAN_OPTIONS})
  add_link_options(${TSAN_OPTIONS})
else()
  message(STATUS ">>> USE_TSAN: NO")
endif()


# per-target
# target_compile_options(${TARGET} PUBLIC -fsanitize=thread -fno-omit-frame-pointer)
# target_link_options(${TARGET} INTERFACE -fsanitize=thread)