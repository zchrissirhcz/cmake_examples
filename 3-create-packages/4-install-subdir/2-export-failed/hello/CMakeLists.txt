add_library(hello STATIC hello.c)
target_include_directories(hello 
  PUBLIC ${CMAKE_CURRENT_SOURCE_DIR} # this cause error when `install(EXPORT hello)`
)