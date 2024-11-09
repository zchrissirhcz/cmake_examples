cmake_minimum_required(VERSION 3.10)
project(use_opencv)

set(CMAKE_CXX_STANDARD 11)

set(OpenCV_RUNTIME vc16)
set(OpenCV_ARCH x64)
set(OpenCV_DIR "D:/pkgs/opencv/4.9.0/build")
find_package(OpenCV REQUIRED)

add_executable(hello hello.cpp)
target_link_libraries(hello PRIVATE ${OpenCV_LIBS})

set_target_properties(
  hello PROPERTIES
  VS_DEBUGGER_ENVIRONMENT "PATH=D:/pkgs/opencv/4.9.0/build/x64/vc16/bin;%PATH%"
)