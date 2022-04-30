cmake_minimum_required(VERSION 3.15)

project(demo)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

option(BUILD_FACE "build face?" OFF)
option(BUILD_CAR  "build car? " OFF)

if((NOT BUILD_FACE) AND (NOT BUILD_CAR))
    message(FATAL_ERROR "please turn on either BUILD_FACE or BUILD_CAR")
endif()

if(BUILD_FACE)
    add_definitions(-DUSE_FACE)
    add_subdirectory(face)
endif()

if(BUILD_CAR)
    add_definitions(-DUSE_CAR)
    add_subdirectory(car)
endif()


add_executable(testbed
    exe/testbed.cpp
)

if(BUILD_FACE)
    target_include_directories(testbed PUBLIC ${CMAKE_SOURCE_DIR}/face)
    target_link_libraries(testbed face)
endif()

if(BUILD_CAR)
    target_include_directories(testbed PUBLIC ${CMAKE_SOURCE_DIR}/car)
    target_link_libraries(testbed car)
endif()

