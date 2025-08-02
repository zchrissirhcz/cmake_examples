cmake_minimum_required(VERSION 3.10)
project(x)

set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/install)

add_library(foo SHARED foo.c)
add_executable(demo demo.c)
target_link_libraries(demo PRIVATE foo)

install(TARGETS foo LIBRARY DESTINATION lib COMPONENT foo)
install(TARGETS demo RUNTIME DESTINATION bin COMPONENT demo)

set_target_properties(demo PROPERTIES
  INSTALL_RPATH "$ORIGIN/../lib"
)