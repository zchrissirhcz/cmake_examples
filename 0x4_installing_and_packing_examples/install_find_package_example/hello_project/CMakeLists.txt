#------------------------------------------------------------
# setup default install directory
# (must in the beginning)
#------------------------------------------------------------
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
    set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install" CACHE PATH "Installation Directory")
endif()
message(STATUS "CMAKE_INSTALL_PREFIX = ${CMAKE_INSTALL_PREFIX}")


cmake_minimum_required(VERSION 3.17)

project(demo)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 11)

#------------------------------------------------------------
# library
#------------------------------------------------------------
add_library(hello STATIC
    hello.h
    hello.cpp
)

#------------------------------------------------------------
# install
#------------------------------------------------------------
install(TARGETS hello
    ARCHIVE DESTINATION lib
)
install(FILES hello.h
    DESTINATION include
)
configure_file(${CMAKE_SOURCE_DIR}/cmake/helloConfig.cmake.in helloConfig.cmake @ONLY)
install(FILES ${CMAKE_BINARY_DIR}/helloConfig.cmake DESTINATION .)