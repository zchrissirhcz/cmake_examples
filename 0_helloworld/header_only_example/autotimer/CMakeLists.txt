
add_library(autotimer INTERFACE
  autotimer.hpp
)
target_include_directories(autotimer INTERFACE
  ${CMAKE_CURRENT_SOURCE_DIR}
)