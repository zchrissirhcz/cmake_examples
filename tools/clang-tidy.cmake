# Author: Zhuo Zhang <imzhuo@foxmail.com>
# Homepage: https://github.com/zchrissirhcz
# Last update: 2023-09-22 15:20:00

# This cmake plugin let you run clang-tidy on specified target
# Each time you run "make", it report warnings if potential bug found
#
# Usage:
# include(clang-tidy.cmake)
# cvpkg_apply_clang_tidy(${your_target})

if(CLANG_TIDY_INCLUDE_GUARD)
  return()
endif()
set(CLANG_TIDY_INCLUDE_GUARD 1)

if(ANDROID AND (CMAKE_SYSTEM_NAME MATCHES "Windows"))
  set(CLANG_TIDY_EXE "clang-tidy")  # NDK's clang-tidy.exe doesn't work on Windows
else()
  find_program(CLANG_TIDY_EXE NAMES "clang-tidy" REQUIRED)
endif()

if(CLANG_TIDY_EXE)
  message(STATUS "CLANG_TIDY_EXE is: ${CLANG_TIDY_EXE}")
else()
  message(FATAL_ERROR "Failed to find clang-tidy executable file")
  # "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/Llvm/x64/bin/clang-tidy.exe"
  # "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.0/LLVM-16.0.0-win64.exe"
endif()

function(cvpkg_apply_clang_tidy targetName)
  # collecting absolute paths for each source file in the given target
  get_target_property(target_sources ${targetName} SOURCES)
  get_target_property(target_source_dir ${targetName} SOURCE_DIR)
  # message(STATUS "target_source_dir: ${target_source_dir}")
  # message(STATUS "target_sources:")
  set(src_path_lst "")
  foreach(target_source ${target_sources})
    # message(STATUS "   ${target_source}")
    if(IS_ABSOLUTE ${target_source})
      set(target_source_absolute_path ${target_source})
    else()
      set(target_source_absolute_path ${target_source_dir}/${target_source})
    endif()
    list(APPEND src_path_lst ${target_source_absolute_path})
  endforeach()

  # prepare clang-tidy command with arguments
  set(clang_tidy_raw_command "${CLANG_TIDY_EXE} -p ${CMAKE_BINARY_DIR} ${src_path_lst}")
  
  # cmake only accept semicolon(;) separated list when a command with arguments is given
  string(REPLACE " " ";" clang_tidy_converted_command "${clang_tidy_raw_command}")
  # message(STATUS "clang_tidy_raw_command: ${clang_tidy_raw_command}")
  # message(STATUS "clang_tidy_converted_command: ${clang_tidy_converted_command}")
  add_custom_target(
    clang-tidy
    COMMAND ${clang_tidy_converted_command}
  )
  add_dependencies(${targetName} clang-tidy)
endfunction()
