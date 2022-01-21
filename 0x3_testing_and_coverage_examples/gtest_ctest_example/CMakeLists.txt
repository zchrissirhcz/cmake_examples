cmake_minimum_required(VERSION 3.17)

project(gtest_example)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 11)

set(GTest_DIR "/home/zz/artifact/googletest/1.11.0/linux-x64/lib/cmake/GTest" CACHE PATH "包含 GTestConfig.cmake 的目录")
find_package(GTest REQUIRED)

add_executable(testbed
    main.cpp
)

target_link_libraries(testbed GTest::gtest)

enable_testing() ##!!
gtest_add_tests(TARGET testbed) ##!! automatically let ctest scan
# then you can run `ctest` or `make test`
# for best practice, `ctest --output-on-failure` is what you need
