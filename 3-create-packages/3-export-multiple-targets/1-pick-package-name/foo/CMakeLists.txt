cmake_minimum_required(VERSION 3.10)
project(foo C)

set(CMAKE_BUILD_TYPE Release)
set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install")
add_library(hello STATIC hello.c)

set(PACKAGE_NAME "foo")

install(FILES hello.h DESTINATION include)
install(TARGETS hello
  EXPORT ${PACKAGE_NAME}
  INCLUDES DESTINATION include
)
install(EXPORT ${PACKAGE_NAME}
  DESTINATION cmake
  FILE ${PACKAGE_NAME}-config.cmake
)