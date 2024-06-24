cmake_minimum_required(VERSION 3.15)

project(demo)

option(USE_A "use a?" OFF)
option(USE_B "use b?" OFF)
option(USE_C "use c?" OFF)

if(USE_A)
    message(STATUS "option: USE_A: ON")
else()
    message(STATUS "option: USE_A: OFF")
endif()

if(USE_B)
    message(STATUS "option: USE_B: ON")
else()
    message(STATUS "option: USE_B: OFF")
endif()

if(USE_C)
    message(STATUS "option: USE_C: ON")
else()
    message(STATUS "option: USE_C: OFF")
endif()

message(STATUS "!! CMAKE_BUILD_TYPE is: ${CMAKE_BUILD_TYPE}")