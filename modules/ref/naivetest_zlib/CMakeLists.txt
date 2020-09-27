cmake_minimum_required(VERSION 3.15)

project(demo)

if(APPLE)
    set(ZLIB_DIR "/Users/chris/soft/zlib/1.2.11" CACHE PATH "")
elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
    set(ZLIB_DIR "/home/zz/soft/zlib/1.2.11" CACHE PATH "")
elseif(CMAKE_SYSTEM_NAME MATCHES "Windows")
    set(ZLIB_DIR "D:/lib/zlib/1.2.11/x64/vc15" CACHE PATH "")
endif()
set(MY_MODULE_DIR "${CMAKE_SOURCE_DIR}/../dist")

#set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})
#list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/modules)
list(INSERT CMAKE_MODULE_PATH 0 ${MY_MODULE_DIR})

set(ZLIB_SHARED ON)
find_package(ZLIB REQUIRED)

add_executable(demo
    src/demo.cpp
)

target_link_libraries(demo ZLIB)

if(MSVC AND ZLIB_SHARED) # copy dll
    get_target_property(ZLIB_DEBUG_DLL ZLIB IMPORTED_LOCATION_DEBUG)
    get_target_property(ZLIB_RELEASE_DLL ZLIB IMPORTED_LOCATION_RELEASE)
    add_custom_command(TARGET demo
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${ZLIB_DEBUG_DLL}
        ${CMAKE_BINARY_DIR}/
    )
    add_custom_command(TARGET demo
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${ZLIB_RELEASE_DLL}
        ${CMAKE_BINARY_DIR}/
    )
endif()
