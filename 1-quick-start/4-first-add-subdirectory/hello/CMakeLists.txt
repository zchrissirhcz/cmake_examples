add_library(hello STATIC
  hello.c
)
target_include_directories(hello PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
)