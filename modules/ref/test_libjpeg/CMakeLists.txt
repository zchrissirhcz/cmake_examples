cmake_minimum_required(VERSION 3.15)

project(demo)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)


set(MY_MODULE_DIR "${CMAKE_SOURCE_DIR}/../dist")
list(INSERT CMAKE_MODULE_PATH 0 ${MY_MODULE_DIR})


if(CMAKE_SYSTEM_NAME MATCHES "Linux")
    set(JPEG_ROOT "/home/zz/soft/libjpeg" CACHE PATH "")
elseif(MSVC)
    set(JPEG_ROOT "E:/lib/libjpeg/x64/vc15" CACHE PATH "")
elseif(APPLE)
    set(JPEG_ROOT "/Users/chris/soft/libjpeg")
endif()


set(JPEG_USE_STATIC_LIBS OFF)
find_package(JPEG REQUIRED)


add_executable(demo src/demo.cpp)
target_link_libraries(demo JPEG::JPEG)

add_custom_command(TARGET demo
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    ${CMAKE_SOURCE_DIR}/girl.jpg
    ${CMAKE_BINARY_DIR}/
)

if(MSVC AND NOT JPEG_USE_STATIC_LIBS) # copy dll
    add_custom_command(TARGET demo
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${JPEG_DLL}
        ${CMAKE_BINARY_DIR}/
    )
endif()
