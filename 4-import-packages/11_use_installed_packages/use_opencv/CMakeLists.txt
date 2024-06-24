cmake_minimum_required(VERSION 3.20)
project(use_benchmark)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(CMAKE_SYSTEM_NAME MATCHES "Linux")
    set(OpenCV_DIR "$ENV{ARTIFACTS_DIR}/opencv/linux-x64/5.x-dev/lib/cmake/opencv5")
elseif(CMAKE_SYSTEM_NAME MATCHES "Windows")
    set(OpenCV_DIR "$ENV{ARTIFACTS_DIR}/opencv/4.7.0-contrib/vs2022-x64/x64/vc17/lib")
    # 写到内层路径，则 vs2019编译器 也可以用 vs2022编译器编译出的库。
    # 如果是写到根目录， 则 opencv 的 cmake 会判别为不支持
endif()
find_package(OpenCV REQUIRED)

#----------------------------------------------------------------------
# testbed
#----------------------------------------------------------------------
add_executable(testbed
    testbed.cpp
)

target_link_libraries(testbed ${OpenCV_LIBS})

