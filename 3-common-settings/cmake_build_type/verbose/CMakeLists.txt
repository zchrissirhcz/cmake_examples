cmake_minimum_required(VERSION 3.5)

# If this is the first time cmake configure is run,
# and no `-DCMAKE_BUILD_TYPE=...` is passed in command line or in xxx.toolchain.cmake,
# and no `CMAKE_BUILD_TYPE` is set in the environment,
# and no `CMAKE_BUILD_TYPE` is set in the cache,
# and not using VSCode's CMake Tools extension for "CMake Configure",
# then CMAKE_BUILD_TYPE is set to an empty string.
message(STATUS "[debug1] CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")

project(x)
message(STATUS "[debug2] CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")

message(STATUS "FLAGS for all build types:")
message(STATUS "  CMAKE_C_FLAGS: ${CMAKE_C_FLAGS}")
message(STATUS "  CMAKE_CXX_FLAGS: ${CMAKE_CXX_FLAGS}")
message(STATUS "  CMAKE_LINKER_FLAGS: ${CMAKE_LINKER_FLAGS}")

if(NOT (CMAKE_BUILD_TYPE EQUAL "None" OR NOT CMAKE_BUILD_TYPE))
  message(STATUS "CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
  string(TOUPPER "${CMAKE_BUILD_TYPE}" capitalized_build_type)
  message(STATUS "  CONFIG: ${capitalized_build_type}")
  message(STATUS "  Capitalized Build Type: ${capitalized_build_type}")
  message(STATUS "  CMAKE_CXX_FLAGS_<CONFIG>: ${CMAKE_CXX_FLAGS_${capitalized_build_type}}")
endif()
