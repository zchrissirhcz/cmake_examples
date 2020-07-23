cmake_minimum_required(VERSION 3.16)

project(bottle)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_library(bottle STATIC
  src/bottle.h
  src/bottle.cpp
)

add_executable(testbed
  src/main.cpp
)
target_link_libraries(testbed
  bottle
)

add_executable(bottle_test
  test/test.cpp
)
target_include_directories(bottle_test
  PUBLIC "src"
)
target_link_libraries(bottle_test
  bottle
)

# 启用测试
enable_testing()
# 测试程序是否成功运行
add_test(test_case1 bottle_test 1 2)


# 测试 1 + 3 , 是否输出打印'is 4'
add_test(test_case2 bottle_test 1 3)
set_tests_properties(test_case2
  PROPERTIES PASS_REGULAR_EXPRESSION "is 4"
)