cmake_minimum_required(VERSION 3.15)

project(demo)

# add_executable(demo
#     src/demo.cpp
# )


#==============================================================
#
# find_file()、find_path()、find_program()、find_package()
#
#==============================================================

set(ZLIB_ROOT "/home/zz/soft/zlib/1.2.11" CACHE PATH "")

#---------------------------------------------------
# finding header files directory
#---------------------------------------------------

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

# TODO: 设定ZLIB::ZLIB这个imported library target


# target_include_directories(demo ${ZLIB_INCLUDE_DIR})
# target_link_libraries(demo ${ZLIB_LIB})
