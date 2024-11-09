cmake_minimum_required(VERSION 3.10)
project(demo)

# find opencv
set(OpenCV_DIR "C:/pkgs/opencv/sources/build/install/lib")
find_package(OpenCV REQUIRED)

# add target
add_executable(demo
  test.cpp
)

# link opencv on target
target_link_libraries(demo PRIVATE
  ${OpenCV_LIBS}
)

# enable asan on target
target_compile_options(demo PRIVATE /fsanitize=address)
target_link_options(demo PRIVATE /fsanitize=address)

# get dll dirs: opencv dll, asan dll
get_filename_component(OpenCV_BIN_DIR "${OpenCV_DIR}/../bin" ABSOLUTE)
get_filename_component(CXX_COMPILER_DIR ${CMAKE_CXX_COMPILER} DIRECTORY)

# add dll dirs to runtime path on target
set_target_properties(
  demo PROPERTIES
  VS_DEBUGGER_ENVIRONMENT "PATH=${OpenCV_BIN_DIR};${CXX_COMPILER_DIR};%PATH%\nASAN_SYMBOLIZER_PATH=${CXX_COMPILER_DIR}"
)
