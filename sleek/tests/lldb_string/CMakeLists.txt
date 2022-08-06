cmake_minimum_required(VERSION 3.20)
project(hello)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 11)

set(CMAKE_BUILD_TYPE Debug)

include("${CMAKE_CURRENT_SOURCE_DIR}/../../sleek.cmake")


if(DEFINED ENV{ARTIFACTS_DIR})
  set(ARTIFACTS_DIR "$ENV{ARTIFACTS_DIR}")
else()
  message(WARNING "ARTIFACTS_DIR env var not defined, abort")
endif()


#--- OpenCV
set(A_VERSION "4.5.5")
if(CMAKE_SYSTEM_NAME MATCHES "Windows")
  set(OpenCV_DIR "${ARTIFACTS_DIR}/opencv/windows/${A_VERSION}")
elseif(ANDROID)
  set(OpenCV_DIR "${ARTIFACTS_DIR}/opencv/android-arm64/${A_VERSION}/sdk/native/jni")
elseif(CMAKE_SYSTEM_NAME MATCHES "Darwin")
  message("not supported platform(${CVPKG_TARGET_PLATFORM}) for package OpenCV")
elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
  set(OpenCV_DIR "${ARTIFACTS_DIR}/opencv/linux-x64/${A_VERSION}/lib/cmake/opencv4")
endif()

message(STATUS ">>> OpenCV_DIR: ${OpenCV_DIR}")
find_package(OpenCV REQUIRED)


# print_cxx_flags()
# add_flag(-fstandalone-debug)
# print_cxx_flags()

sleek_add_flags("-fstandalone-debug")

add_executable(testbed main.cpp)
target_link_libraries(testbed ${OpenCV_LIBS})

