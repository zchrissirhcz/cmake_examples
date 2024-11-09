cmake_minimum_required(VERSION 3.10)
project(logger)

add_subdirectory(logger)
add_executable(use_logger use_logger.cpp)
target_link_libraries(use_logger PRIVATE logger)