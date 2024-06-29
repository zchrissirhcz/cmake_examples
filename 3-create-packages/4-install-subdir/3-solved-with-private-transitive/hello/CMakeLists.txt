add_library(hello STATIC hello.c)
target_include_directories(hello 
  PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}
)