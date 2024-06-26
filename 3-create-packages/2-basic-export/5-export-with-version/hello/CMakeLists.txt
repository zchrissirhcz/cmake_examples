cmake_minimum_required(VERSION 3.5)
project(hello C)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_BUILD_TYPE Release)
set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install")

add_library(hello STATIC hello.c)

install(FILES hello.h DESTINATION include/hello)
install(TARGETS hello
  EXPORT hello
  INCLUDES DESTINATION include
)
install(EXPORT hello
  DESTINATION cmake/hello
  FILE hello-config.cmake
  NAMESPACE hello::
)

# Generate a version file to make find_package() happy
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  hello-config-version.cmake
  VERSION "0.1.0"
  COMPATIBILITY ExactVersion
)
install(
  FILES "${CMAKE_CURRENT_BINARY_DIR}/hello-config-version.cmake"
  DESTINATION cmake/hello
)
# Append to the config file to set the version property
install(CODE "
file(APPEND \"\${CMAKE_INSTALL_PREFIX}/cmake/hello/hello-config.cmake\" \"set_property(TARGET hello::hello PROPERTY VERSION \\\"\\\${PACKAGE_VERSION}\\\")\n\")
")