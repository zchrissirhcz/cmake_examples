cmake_minimum_required(VERSION 3.20)
project(hello)

include(CPM.cmake)

CPMAddPackage(
  NAME googletest
  GITHUB_REPOSITORY google/googletest
  GIT_TAG release-1.11.0
  VERSION 1.11.0
  OPTIONS
      "INSTALL_GTEST OFF"
      "gtest_force_shared_crt ON"
)

enable_testing()
add_executable(testbed testbed.cpp)
target_link_libraries(testbed PUBLIC GTest::gtest)
