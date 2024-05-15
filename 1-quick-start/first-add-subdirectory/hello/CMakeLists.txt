add_library(hello STATIC
  ${CMAKE_CURRENT_SOURCE_DIR}/../../src/hello.cpp
)
target_include_directories(hello PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}/../../src
)