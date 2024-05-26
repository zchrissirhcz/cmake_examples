cmake_minimum_required(VERSION 3.25)
project(find_opencv_dlls_without_copy)
set(CMAKE_CXX_STANDARD 11)

set(OpenCV_DIR "C:/pkgs/opencv/build/x64/vc16/lib")
find_package(OpenCV REQUIRED)
# opencv_videoio_ffmpeg490_64.dll is required during runtime, but it won't give an error if it's not found
# however, program will give unexpected results. We have to find it.
add_executable(demo demo.cpp)
target_link_libraries(demo ${OpenCV_LIBS})

set_target_properties(
  demo PROPERTIES
  VS_DEBUGGER_ENVIRONMENT "PATH=C:/pkgs/opencv/build/x64/vc16/bin;%PATH%"
)