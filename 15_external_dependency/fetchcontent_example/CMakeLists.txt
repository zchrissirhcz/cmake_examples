cmake_minimum_required(VERSION 3.20)

project(example)

#set(CMAKE_POSITION_INDEPENDENT_CODE ON)

include(FetchContent)

set(FETCHCONTENT_BASE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/deps)
set(FETCHCONTENT_QUIET OFF)

set(INSTALL_GTEST OFF CACHE BOOL "")
set(BUILD_SHARED_LIBS OFF CACHE BOOL "")

# 第一种方式： 指定 URL。 HASH值需要自己用md5sum算出来
# FetchContent_Declare(googletest
#     URL https://github.com/google/googletest/archive/refs/tags/release-1.8.1.zip
#     URL_HASH MD5=ad6868782b5952b7476a7c1c72d5a714
#     SOURCE_DIR ${FETCHCONTENT_BASE_DIR}/googletest
#     BINARY_DIR ${FETCHCONTENT_BASE_DIR}/googletest-build
#     SUBBUILD_DIR ${FETCHCONTENT_BASE_DIR}/googletest-subbuild
# )

# 第二种方式： 用 GIT REPO。 GIT_TAG 可以是完整hash，或短hash， 或tag名字
# 为了加速， 可以在 gitee 官网找一下镜像
FetchContent_Declare(googletest
    #GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_REPOSITORY https://gitee.com/mirrors/googletest.git
    
    #GIT_TAG e2239ee6043f73722e7aa812a459f54a28552929
    #GIT_TAG e2239ee6
    GIT_TAG release-1.11.0
    #GIT_TAG release-1.10.0
    SOURCE_DIR ${FETCHCONTENT_BASE_DIR}/googletest
    BINARY_DIR ${FETCHCONTENT_BASE_DIR}/googletest-build
    SUBBUILD_DIR ${FETCHCONTENT_BASE_DIR}/googletest-subbuild
)

FetchContent_MakeAvailable(googletest)

enable_testing()
add_executable(testbed testbed.cpp)

# 链接 gtest： 如果是 1.1.11, 则有 GTest::gtest 和 GTest::gtest_main 可用
target_link_libraries(testbed PUBLIC GTest::gtest)
# 如果是 <= 1.1.10 版本， 则只能 gtest_main
#target_link_libraries(testbed PUBLIC gtest_main)


