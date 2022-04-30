cmake_minimum_required(VERSION 3.15)

project(demo)

# since doctest's source code is large (~250k), and doctest.zip is ~50k
# I'd like to put doctest.zip instead of its source files in this repo
# And when using it, we let cmake extract it.
if(EXISTS "${CMAKE_SOURCE_DIR}/doctest"
    AND EXISTS "${CMAKE_SOURCE_DIR}/doctest/doctest_fwd.h"
    AND EXISTS "${CMAKE_SOURCE_DIR}/doctest/doctest.cpp"
)
    message(STATUS "--- doctest source code ready !")
else()
    message(STATUS "--- extracting doctest source code from zip...")
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E tar xzf ${CMAKE_SOURCE_DIR}/doctest.zip
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
endif()

add_library(doctest STATIC
    doctest/doctest_fwd.h
    doctest/doctest.cpp
)
target_compile_definitions(doctest PRIVATE -DDOCTEST_CONFIG_IMPLEMENT_WITH_MAIN)

add_executable(demo
    src/main.cpp
)
target_link_libraries(demo doctest)
target_include_directories(demo
    PUBLIC "${CMAKE_SOURCE_DIR}/doctest"
)