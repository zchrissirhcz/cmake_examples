cmake_minimum_required(VERSION 3.15)

project(cmake_pkg_config_example)

#指定pkg-config.exe绝对路径
set(PKG_CONFIG_EXECUTABLE "D:/soft/pkg-config/bin/pkg-config.exe")

#指定zlib.pc所在目录
set(ENV{PKG_CONFIG_PATH} "D:/lib/pangolin/share/pkgconfig")

find_package(PkgConfig)
message(STATUS "--- PKG_CONFIG_FOUND: ${PKG_CONFIG_FOUND}")
message(STATUS "--- PKG_CONFIG_VERSION_STRING: ${PKG_CONFIG_VERSION_STRING}")

pkg_search_module(ZLIB REQUIRED zlib)

message(STATUS "=== ZLIB_LIBRARIES: ${ZLIB_LIBRARIES}")
message(STATUS "=== ZLIB_INCLUDE_DIRS: ${ZLIB_INCLUDE_DIRS}")
