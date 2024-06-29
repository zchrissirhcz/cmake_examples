cmake_minimum_required(VERSION 3.5)
project(foo)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_BUILD_TYPE Release)
set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install")

add_subdirectory(hello)

install(FILES hello/hello.h DESTINATION include)
install(TARGETS hello
  EXPORT hello
  INCLUDES DESTINATION include
)
install(EXPORT hello
  DESTINATION cmake
  FILE hello-config.cmake
)
