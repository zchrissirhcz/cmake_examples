# Get cJSON from https://github.com/DaveGamble/cJSON
add_library(cJSON STATIC
  ${CMAKE_CURRENT_SOURCE_DIR}/cJSON.h
  ${CMAKE_CURRENT_SOURCE_DIR}/cJSON.cpp
)
target_include_directories(cJSON PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
)