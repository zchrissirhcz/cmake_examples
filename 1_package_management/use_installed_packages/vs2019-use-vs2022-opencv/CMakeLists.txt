cmake_minimum_required(VERSION 3.20)
project(x)
set(CMAKE_CXX_STANDARD 11)

set(OpenCV_RUNTIME vc17)
set(OpenCV_ARCH x64)
set(OpenCV_DIR "D:/artifacts/opencv/4.7.0-contrib/vs2022-x64")
# 或一步到位: set(OpenCV_DIR "$ENV{ARTIFACTS_DIR}/opencv/4.7.0-contrib/vs2022-x64/x64/vc17/lib")
find_package(OpenCV REQUIRED)