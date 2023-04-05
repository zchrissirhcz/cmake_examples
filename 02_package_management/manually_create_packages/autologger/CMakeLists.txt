add_library(autologger INTERFACE
  autologger.hpp
)
target_include_directories(autologger INTERFACE
  ${CMAKE_CURRENT_SOURCE_DIR}
)