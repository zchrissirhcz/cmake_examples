cmake_minimum_required(VERSION 3.10)
project(x)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_BUILD_TYPE Release)
set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/install)

# library
add_library(hello STATIC
  hello.h
  hello.cpp
)

# executable
add_executable(say_hello
  say_hello.cpp
)
target_include_directories(say_hello PRIVATE ${CMAKE_SOURCE_DIR})
target_link_libraries(say_hello hello)

# install
install(TARGETS hello say_hello
  ARCHIVE DESTINATION lib
  RUNTIME DESTINATION bin
)
install(FILES hello.h
  DESTINATION include
)
