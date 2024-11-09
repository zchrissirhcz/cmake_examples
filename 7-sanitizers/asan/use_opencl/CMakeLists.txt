cmake_minimum_required(VERSION 3.10)
project(use_opencl_with_asan)

add_executable(test test.cpp)

if(CMAKE_SYSTEM_NAME MATCHES "Darwin")
  # brew install ocl-icd
  # brew install opencl-headers
  add_library(ocl-icd SHARED IMPORTED)
  set_target_properties(ocl-icd PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "/opt/homebrew/opt/opencl-headers/include"
    IMPORTED_LOCATION "/opt/homebrew/opt/ocl-icd/lib/libOpenCL.dylib"
  )
  target_link_libraries(test PRIVATE ocl-icd)
endif()

target_compile_options(test PRIVATE -fsanitize=thread -fno-omit-frame-pointer -g)
target_link_options(test PRIVATE -fsanitize=thread)

