cmake_minimum_required(VERSION 3.20)
project(find_package_example)
set(CMAKE_CXX_STANDARD 11)

if(CMAKE_SYSTEM_NAME MATCHES "Windows")
  set(OpenCV_DIR "C:/Users/zz/work/opencv/4.7.0/build/x64/vc16/lib")
endif()
find_package(OpenCV REQUIRED)

add_executable(test_opencv test_opencv.cpp)
target_link_libraries(test_opencv PUBLIC ${OpenCV_LIBS})

message(STATUS "OpenCV_LIBS are: ${OpenCV_LIBS}")