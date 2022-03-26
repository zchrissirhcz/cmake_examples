cmake_minimum_required(VERSION 3.20)
project(hello)

set(CMAKE_CXX_STANDARD 11)

option(DEP_USE_GITEE "get dependencies from gitee" ON)

### dependencies
include(FetchContent)

set(FETCHCONTENT_BASE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/deps)
set(FETCHCONTENT_QUIET OFF)


set(INSTALL_GTEST OFF CACHE BOOL "")
set(BUILD_SHARED_LIBS OFF CACHE BOOL "")


if(DEP_USE_GITEE)
    set(googletest_repo https://gitee.com/mirrors/googletest.git)
else()
    set(googletest_repo https://github.com/google/googletest.git)
endif()


FetchContent_Declare(googletest
    GIT_REPOSITORY ${googletest_repo}
    GIT_TAG release-1.11.0
    SOURCE_DIR ${FETCHCONTENT_BASE_DIR}/googletest
    BINARY_DIR ${FETCHCONTENT_BASE_DIR}/googletest-build
    SUBBUILD_DIR ${FETCHCONTENT_BASE_DIR}/googletest-subbuild
)

FetchContent_MakeAvailable(googletest)

enable_testing()
add_executable(testbed testbed.cpp)
target_link_libraries(testbed PUBLIC GTest::gtest)