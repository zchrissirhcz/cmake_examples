cmake_minimum_required(VERSION 3.15)

project(demo)

set(ENV{PKG_CONFIG_PATH} /usr/lib/x86_64-linux-gnu/pkgconfig)
find_package(PkgConfig)
if(NOT PKG_CONFIG_FOUND)
    message(FATAL_ERROR "--- pkg-config command not found")
endif()
pkg_check_modules(LMDB REQUIRED lmdb)


message(STATUS "=== LMDB_LIBRARIES: ${LMDB_LIBRARIES}")
message(STATUS "=== LMDB_INCLUDEDIR is: ${LMDB_INCLUDEDIR}")

add_executable(demo
    src/lmdb-demo.c
)

target_include_directories(demo
    PRIVATE ${LMDB_INCLUDEDIR}
)
target_link_libraries(demo
    ${LMDB_LIBRARIES}
)

execute_process(COMMAND mkdir testdb)