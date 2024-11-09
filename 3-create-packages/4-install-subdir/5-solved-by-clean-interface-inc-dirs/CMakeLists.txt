cmake_minimum_required(VERSION 3.10)
project(foo)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_BUILD_TYPE Release)
set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install")

add_subdirectory(hello)


# Remove the include directories that are not in the current source or binary directory
# set_target_properties(hello PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "")
get_target_property(hello_interface_incs hello INTERFACE_INCLUDE_DIRECTORIES)
set(final_interface_incs "")
foreach(inc ${hello_interface_incs})
  if("${inc}" MATCHES "^(${CMAKE_CURRENT_SOURCE_DIR}|${CMAKE_CURRENT_BINARY_DIR})")
    continue()
  endif()
  list(APPEND final_interface_incs ${inc})
endforeach()
set_target_properties(hello PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${final_interface_incs}")
unset(final_interface_incs)


install(FILES hello/hello.h DESTINATION include)
install(TARGETS hello
  EXPORT hello
  INCLUDES DESTINATION include
)
install(EXPORT hello
  DESTINATION cmake
  FILE hello-config.cmake
)
