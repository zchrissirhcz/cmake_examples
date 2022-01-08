#------------------------------------------------------------
# setup default install directory
# (must in the beginning)
#------------------------------------------------------------
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install" CACHE PATH "Installation Directory")
endif()
message(STATUS "CMAKE_INSTALL_PREFIX = ${CMAKE_INSTALL_PREFIX}")


cmake_minimum_required(VERSION 3.20)
project(hello)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(hello_api_files
    ${CMAKE_SOURCE_DIR}/api/hello/hello.hpp
)
set(hello_src_files
    ${CMAKE_SOURCE_DIR}/src/hello/hello.cpp
)
set(hello_api_dir
    ${CMAKE_SOURCE_DIR}/api
)
set(hello_src_dir
    ${CMAKE_SOURCE_DIR}/src
)

add_library(hello STATIC
    ${hello_api_files}
    ${hello_src_files}
)

# we have to separately specify include search path for 
# - build interface: for the target itself
# - install interface: for the clients that use this library(package)
target_include_directories(hello
    PUBLIC
        $<BUILD_INTERFACE:${hello_api_dir}>
        $<INSTALL_INTERFACE:include>
    PRIVATE
        $<BUILD_INTERFACE:${hello_src_dir}>
)

# Intall the hello target
# - install its library files
# - export as `helloTargets`, being used for the `install(EXPORT helloTargets ...)`
install(TARGETS hello
    DESTINATION lib
    EXPORT helloTargets
)
# Install public header files, i.e. the API
install(
    FILES
        ${hello_api_files}
    DESTINATION
        include/hello
)

# Generate package management files for the export `helloTargets`
# - ${CMAKE_INSTALL_PREFIX}/lib/cmake/hello/helloTargets.cmake
# - ${CMAKE_INSTALL_PREFIX}/lib/cmake/hello/helloTargets-*.cmake , `*` accoriding to ${CMAKE_BUILD_TYPE}, e.g.:
#   - ${CMAKE_INSTALL_PREFIX}/lib/cmake/hello/helloTargets-Release.cmake     for CMAKE_BUILD_TYPE=Release
#   - ${CMAKE_INSTALL_PREFIX}/lib/cmake/hello/helloTargets-Debug.cmake       for CMAKE_BUILD_TYPE=Debug
#   - ${CMAKE_INSTALL_PREFIX}/lib/cmake/hello/helloTargets-nonconfig.cmake   for CMAKE_BUILD_TYPE not specified
#   - ${CMAKE_INSTALL_PREFIX}/lib/cmake/hello/helloTargets-what.cmake        for CMAKE_BUILD_TYPE=what, defined as the user like
install(EXPORT helloTargets DESTINATION lib/cmake/hello)

# Generate ${CMAKE_BUILD_DIR}/cmake/helloConfig.cmake from cmake/helloConfig.cmake.in
configure_file(${CMAKE_SOURCE_DIR}/cmake/helloConfig.cmake.in helloConfig.cmake @ONLY)

# generate ${CMAKE_INSTALL_PREFIX}/lib/cmake/hello/helloConfig.cmake
install(FILES ${CMAKE_BINARY_DIR}/helloConfig.cmake DESTINATION lib/cmake/hello)