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
# executable
#------------------------------------------------------------
add_executable(say_hello
    say_hello.cpp
)
target_include_directories(say_hello PRIVATE ${CMAKE_SOURCE_DIR})
target_link_libraries(say_hello hello)

#------------------------------------------------------------
# install
#------------------------------------------------------------
install(TARGETS hello say_hello
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
)
install(FILES hello.h
    DESTINATION include
)
