# Author: ChrisZZ <imzhuo@foxmail.com>
# Homepage: https://github.com/zchrissirhcz
# Last update: 2023-05-15 10:38:59

# globally
set(TSAN_AVAILABLE ON)
if((CMAKE_C_COMPILER_ID STREQUAL "MSVC") OR (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
      OR ((MSVC AND ((CMAKE_C_COMPILER_ID STREQUAL "Clang") OR (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")))))
  message(WARNING "Neither MSVC nor Clang-CL support thread sanitizer")
  set(TSAN_AVAILABLE OFF)
elseif((CMAKE_C_COMPILER_ID MATCHES "GNU") OR (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    OR (CMAKE_C_COMPILER_ID MATCHES "Clang") OR (CMAKE_CXX_COMPILER_ID MATCHES "Clang"))
  set(TSAN_OPTIONS -fsanitize=thread -fno-omit-frame-pointer -g)
endif()

if(TSAN_AVAILABLE)
  message(STATUS ">>> USE_TSAN: YES")
  add_compile_options(${TSAN_OPTIONS})
  add_link_options(${TSAN_OPTIONS})
else()
  message(STATUS ">>> USE_TSAN: NO")
endif()


# per-target
# target_compile_options(${TARGET} PUBLIC -fsanitize=thread -fno-omit-frame-pointer)
# target_link_options(${TARGET} INTERFACE -fsanitize=thread)