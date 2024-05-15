cmake_minimum_required(VERSION 3.25)
project(test_opencv)
set(CMAKE_CXX_STANDARD 11)

if(CMAKE_SYSTEM_NAME MATCHES "Windows")
  set(OpenCV_DIR "C:/Users/zz/work/opencv/4.9.0/build/x64/vc16/lib")
endif()
find_package(OpenCV REQUIRED)
message(STATUS "OpenCV_LIBS are: ${OpenCV_LIBS}")

add_executable(test_opencv test_opencv.cpp)
target_link_libraries(test_opencv PUBLIC ${OpenCV_LIBS})
