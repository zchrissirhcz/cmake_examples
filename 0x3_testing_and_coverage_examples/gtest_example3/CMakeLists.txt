cmake_minimum_required(VERSION 3.20)

project(gtest_example3)

find_package(GTest REQUIRED)

enable_testing()

add_executable(
  hello_test
  hello_test.cc
)
target_link_libraries(
  hello_test
  GTest::gtest
  #gtest_main # apt装的gtest是ok的，但自行编译的则失败
  GTest::gtest_main #ok
)

gtest_discover_tests(hello_test)

