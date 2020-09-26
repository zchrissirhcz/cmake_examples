cmake_minimum_required(VERSION 3.15)

project(demo)

set(MY_MODULE_DIR ${CMAKE_SOURCE_DIR}/../modules/dist)
list(INSERT CMAKE_MODULE_PATH 0 ${MY_MODULE_DIR})

add_executable(demo
    src/tjexample.c
)

if(MSVC)
    set(JPEGTURBO_ROOT "D:/lib/libjpeg-turbo" CACHE PATH "")
elseif(APPLE)
    set(JPEGTURBO_ROOT "/Users/chris/soft/libjpeg-turbo" CACHE PATH "")
endif()
set(JPEGTURBO_USE_STATIC_LIBS ON)
find_package(JPEGTURBO REQUIRED)

target_link_libraries(demo JPEGTURBO::JPEGTURBO)

add_custom_command(TARGET demo
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    ${CMAKE_SOURCE_DIR}/girl.jpg
    ${CMAKE_BINARY_DIR}/
)

if(MSVC AND NOT JPEGTURBO_USE_STATIC_LIBS) # copy dll
    add_custom_command(TARGET demo
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${JPEGTURBO_DLL}
        ${CMAKE_BINARY_DIR}/
    )
endif()
