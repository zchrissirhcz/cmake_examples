cmake_minimum_required(VERSION 3.15)

project(demo)

# add_executable(demo
#     src/demo.cpp
# )

#set(MY_MODULE_DIR ${CMAKE_SOURCE_DIR}/../modules/neat)
set(MY_MODULE_DIR "${CMAKE_SOURCE_DIR}/../dist")
list(INSERT CMAKE_MODULE_PATH 0 ${MY_MODULE_DIR})

#==============================================================
#
# find_file()、find_path()、find_program()、find_package()
#
#==============================================================

if(CMAKE_SYSTEM_NAME MATCHES "Linux")
    set(ZLIB_ROOT "/home/zz/soft/zlib/1.2.11" CACHE PATH "")
    #set(ZLIB_DIR  "/home/zz/soft/zlib/1.2.11" CACHE PATH "")
elseif(MSVC)
    #set(ZLIB_ROOT "E:/lib/zlib/1.2.11/x64/vc15" CACHE PATH "")
    #set(ZLIB_DIR  "E:/lib/zlib/1.2.11/x64/vc15" CACHE PATH "")
elseif(APPLE)
    set(ZLIB_ROOT "/Users/chris/soft/zlib/1.2.11" CACHE PATH "")
endif()

#---------------------------------------------------
# finding header files directory
#---------------------------------------------------
#[[
find_path(ZLIB_INCLUDE_DIR
    NAMES zlib.h zconf.h
    HINTS ${ZLIB_ROOT}/include
    REQUIRED
)

message(STATUS "--- ZLIB_INCLUDE_DIR is: ${ZLIB_INCLUDE_DIR}")


find_path(ZLIB_LIBRARY_DIR
    NAMES
        zlib.lib zlibd.lib
        libz.dylib
        libz.so
        zlibstatic.lib zlibstaticd.lib
        libz.a
    HINTS ${ZLIB_ROOT}/lib /usr/lib/x86_64-linux-gnu
    REQUIRED
)

message(STATUS "--- ZLIB_LIBRARY_DIR is: ${ZLIB_LIBRARY_DIR}")
#]]
# TODO: 设定ZLIB::ZLIB这个imported library target


# target_include_directories(demo ${ZLIB_INCLUDE_DIR})
# target_link_libraries(demo ${ZLIB_LIB})

set(ZLIB_USE_STATIC_LIBS ON)
#set(ZLIB_SHARED ON)
find_package(ZLIB REQUIRED)


message(STATUS "--- ZLIB_INCLUDE_DIRS is: ${ZLIB_INCLUDE_DIRS}")
message(STATUS "--- ZLIB_LIBRARIES: ${ZLIB_LIBRARIES}")

add_executable(demo src/demo.cpp)
#target_include_directories(demo PUBLIC ${ZLIB_INCLUDE_DIR})
target_link_libraries(demo ZLIB::ZLIB)

if(MSVC AND NOT ZLIB_USE_STATIC_LIBS) # copy dll
    #get_target_property(ZLIB_DEBUG_DLL ZLIB::ZLIB IMPORTED_LOCATION_DEBUG)
    #get_target_property(ZLIB_RELEASE_DLL ZLIB::ZLIB IMPORTED_LOCATION_RELEASE)
    #set(ZLIB_DLL
    #    $<$<CONFIG:Debug>:"${ZLIB_DEBUG_DLL}">
    #    $<$<CONFIG:Release>:"${ZLIB_RELEASE_DLL}">
    #)
    add_custom_command(TARGET demo
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${ZLIB_DLL}
        ${CMAKE_BINARY_DIR}/
    )
    # add_custom_command(TARGET demo
    #     POST_BUILD
    #     COMMAND ${CMAKE_COMMAND} -E copy_if_different
    #     ${ZLIB_DEBUG_DLL}
    #     ${CMAKE_BINARY_DIR}/
    # )
    # add_custom_command(TARGET demo
    #     POST_BUILD
    #     COMMAND ${CMAKE_COMMAND} -E copy_if_different
    #     ${ZLIB_RELEASE_DLL}
    #     ${CMAKE_BINARY_DIR}/
    # )
endif()

