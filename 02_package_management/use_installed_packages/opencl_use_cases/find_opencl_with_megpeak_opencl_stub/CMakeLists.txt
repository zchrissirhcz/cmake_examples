cmake_minimum_required(VERSION 3.20)

project(use_opencl)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include(cmake/deps.cmake)

# OpenCL Headers
# https://github.com/KhronosGroup/OpenCL-Headers.git
set(OpenCLHeaders_DIR "${ARTIFACTS_DIR}/OpenCL-Headers/share/cmake/OpenCLHeaders")
find_package(OpenCLHeaders REQUIRED)

# OpenCL Library
# https://github.com/MegEngine/MegPeak/tree/main/opencl-stub
set(opencl_stub_src_dir "/home/zz/work/MegPeak/opencl-stub")
add_subdirectory(${opencl_stub_src_dir}
  ${CMAKE_BINARY_DIR}/opencl-stub
)

add_executable(testbed
  testbed.cpp
)
target_include_directories(testbed PUBLIC ${opencl_stub_src_dir}/include/)
target_link_libraries(testbed
  PRIVATE
    OpenCL::Headers
    OpenCL dl
)
