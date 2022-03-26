cmake_minimum_required(VERSION 3.20)
project(hello)

set(FETCHCONTENT_QUIET OFF)
include(CPM.cmake)

CPMAddPackage(
  NAME opencv
  #GITHUB_REPOSITORY google/googletest
  GIT_REPOSITORY https://gitee.com/mirrors/opencv
  GIT_TAG 4.4.0
  VERSION 4.4.0
  GIT_SHALLOW ON
  GIT_PROGRESS ON
  OPTIONS
      "BUILD_TESTS OFF"
      "BUILD_PERF_TESTS OFF"
      "BUILD_EXAMPLES OFF"
      "BUILD_opencv_apps OFF"
      "WITH_CUDA OFF"
      "BUILD_LIST core,imgproc,calib3d"
)

enable_testing()
add_executable(testbed testbed.cpp)

set(OpenCV_DIR "/home/zz/work/cmake_examples/13_misc/cpm_example2/build")
find_package(OpenCV REQUIRED)
target_link_libraries(testbed PUBLIC ${OpenCV_LIBS})
#target_link_libraries(testbed PUBLIC opencv_imgproc opencv_core)
