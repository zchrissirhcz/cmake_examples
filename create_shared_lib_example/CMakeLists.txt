cmake_minimum_required(VERSION 3.15)

project(demo)

if (WIN32)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY $<1:${CMAKE_SOURCE_DIR}/bin>)
endif()

add_library(get_three SHARED
    get_three.cpp
)

add_library(get_seven SHARED
    get_seven.cpp
)
target_include_directories(get_three PUBLIC ${CMAKE_SOURCE_DIR})
target_include_directories(get_seven PUBLIC ${CMAKE_SOURCE_DIR})


add_executable(testbed
    test.cpp
)
target_link_libraries(testbed get_three get_seven)

if (WIN32)
set_target_properties(
    testbed PROPERTIES
    VS_DEBUGGER_WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}/bin")
endif()