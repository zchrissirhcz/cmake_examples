cmake_minimum_required(VERSION 3.15)

project(demo)

set(MY_MODULE_DIR ${CMAKE_SOURCE_DIR}/../modules/dist)
list(INSERT CMAKE_MODULE_PATH 0 ${MY_MODULE_DIR})

add_executable(demo
    src/tjexample.c
)

set(JPEGTURBO_USE_STATIC_LIBS ON)
find_package(JPEGTURBO REQUIRED)

target_link_libraries(demo JPEGTURBO::JPEGTURBO)

add_custom_command(TARGET demo
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    ${CMAKE_SOURCE_DIR}/girl.jpg
    ${CMAKE_BINARY_DIR}/
)
