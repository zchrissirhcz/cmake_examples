add_library(logger INTERFACE
  logger.hpp
)
target_include_directories(logger INTERFACE
  ${CMAKE_CURRENT_SOURCE_DIR}
)