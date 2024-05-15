# Author: Zhuo Zhang <imzhuo@foxmail.com>
# Homepage: https://github.com/zchrissirhcz
# Last update: 2023-09-22 15:20:00

# When building a CMake-based project, Ninja may speedup the building speed, comparing to Make.
# However, with `-GNinja` specified, compile errors are with no obvious colors.
# This cmake plugin just solve this mentioned problem, giving colorful output for Ninja.
## References: https://medium.com/@alasher/colored-c-compiler-output-with-ninja-clang-gcc-10bfe7f2b949

if(NINJA_COLORFUL_OUTPUT_INCLUDE_GUARD)
  return()
endif()
set(NINJA_COLORFUL_OUTPUT_INCLUDE_GUARD 1)

option(NINJA_COLORFUL_OUTPUT "Always produce ANSI-colored output (GNU/Clang only)." ON)

if(${NINJA_COLORFUL_OUTPUT})
  if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    set(NINJA_COLORFUL_OUTPUT_OPTION -fdiagnostics-color=always)
  elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(NINJA_COLORFUL_OUTPUT_OPTION -fcolor-diagnostics)
  else()
    message(WARNING "Ninja colorful output not handled or not supported for current compiler")
    return()
  endif()

  message(STATUS ">>> NINJA_COLORFUL_OUTPUT: YES")
  add_compile_options(${NINJA_COLORFUL_OUTPUT_OPTION})
endif()
