# Author: Zhuo Zhang <imzhuo@foxmail.com>
# Homepage: https://github.com/zchrissirhcz
# Last update: 2023-08-21 22:53:00

# This cmake plugin let you run clang-tidy on specified target
# Each time you run "make", it report warnings if potential bug found
#
# Usage:
# include(clang-tidy.cmake)
# cvpkg_apply_clang_tidy(${your_target})

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
  get_target_property(target_sources ${targetName} SOURCES)
  get_target_property(target_source_dir ${targetName} SOURCE_DIR)
  message(STATUS "target_sources: ${target_sources}")
  message(STATUS "target_source_dir: ${target_source_dir}")
  add_custom_target(
    clang-tidy
    COMMAND ${CLANG_TIDY_EXE} -p ${CMAKE_BINARY_DIR} ${target_source_dir}/${target_sources}
  )
  add_dependencies(${targetName} clang-tidy)
endfunction()
