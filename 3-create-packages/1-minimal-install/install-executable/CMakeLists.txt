cmake_minimum_required(VERSION 3.5)
project(x)

set(CMAKE_BUILD_TYPE Release)
set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/install)

add_executable(test test.c)
install(TARGETS test DESTINATION bin)