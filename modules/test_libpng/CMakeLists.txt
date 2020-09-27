cmake_minimum_required(VERSION 3.15)

project(demo)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)


set(MY_MODULE_DIR "${CMAKE_SOURCE_DIR}/../dist")
list(INSERT CMAKE_MODULE_PATH 0 ${MY_MODULE_DIR})


if(CMAKE_SYSTEM_NAME MATCHES "Linux")
    #set(PNG_ROOT "/home/zz/soft/libpng" CACHE PATH "")
elseif(MSVC)
    set(PNG_ROOT "E:/lib/libpng" CACHE PATH "")
elseif(APPLE)
    set(PNG_ROOT "/Users/chris/soft/libpng")
endif()
set(PNG_USE_STATIC_LIBS OFF)
find_package(PNG REQUIRED)


add_executable(demo src/demo.cpp)
target_link_libraries(demo PNG::PNG)

add_custom_command(TARGET demo
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    ${CMAKE_SOURCE_DIR}/op.png
    ${CMAKE_BINARY_DIR}/
)

if(MSVC AND NOT PNG_USE_STATIC_LIBS) # copy dll
    add_custom_command(TARGET demo
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${PNG_DLL}
        ${CMAKE_BINARY_DIR}/
    )
endif()