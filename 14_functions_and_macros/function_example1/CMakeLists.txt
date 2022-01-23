cmake_minimum_required(VERSION 3.20)
project(exp)

function(cvpkg_config_gtest OUTPUT_VAR)
  set(${OUTPUT_VAR} "/home/zz/artifacts/googletest/1.11.0/linux-x64/lib/cmake/GTest" PARENT_SCOPE)
endfunction()

set(GTest_DIR "")
cvpkg_config_gtest(GTest_DIR)

message("GTest_DIR is: ${GTest_DIR}")

