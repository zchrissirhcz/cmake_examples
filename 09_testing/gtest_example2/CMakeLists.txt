cmake_minimum_required(VERSION 3.17)

project(gtest_example)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 11)

if(CMAKE_SYSTEM_NAME MATCHES "Linux")
    set(GTest_DIR "/home/zz/artifact/googletest/1.11.0/linux-x64/lib/cmake/GTest")
elseif(CMAKE_SYSTEM_NAME MATCHES "Windows")
    set(GTest_DIR "D:/dev/googletest/build/vs2019-x64/install/lib/cmake/GTest")
elseif(ANDROID)
    set(GTest_DIR "/home/zz/artifact/googletest/1.11.0/android-arm64/lib/cmake/GTest")
endif()
find_package(GTest REQUIRED)


set(OpenCV_DIR "D:/lib/opencv/4.5.2-pre")
find_package(OpenCV REQUIRED)

add_executable(testbed
    testbed.cpp
)

target_link_libraries(testbed PUBLIC
    ${OpenCV_LIBS}
    GTest::gtest
)
