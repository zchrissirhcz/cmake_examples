cmake_minimum_required(VERSION 3.15)

project(demo)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)


set(MY_MODULE_DIR ${CMAKE_SOURCE_DIR}/../modules/dist)
list(INSERT CMAKE_MODULE_PATH 0 ${MY_MODULE_DIR})


set(PNG_ROOT "/home/zz/soft/libpng" CACHE PATH "")
set(PNG_USE_STATIC_LIBS ON)
find_package(PNG REQUIRED)


add_executable(demo src/demo.cpp)
target_link_libraries(demo PNG::PNG)

add_custom_command(TARGET demo
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    ${CMAKE_SOURCE_DIR}/op.png
    ${CMAKE_BINARY_DIR}/
)