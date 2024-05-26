cmake_minimum_required(VERSION 3.20)

project(graphviz_use)

set(ENV{PKG_CONFIG_PATH} /usr/lib/x86_64-linux-gnu/pkgconfig)
find_package(PkgConfig)
pkg_search_module(graphviz REQUIRED libgvc)


