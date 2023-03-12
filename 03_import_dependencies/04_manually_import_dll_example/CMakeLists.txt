cmake_minimum_required(VERSION 3.20)
project(x)

# ftp://sourceware.org/pub/pthreads-win32/pthreads-w32-2-9-1-release.zip
add_library(win_pthread SHARED IMPORTED)
set_target_properties(win_pthread PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES D:/artifacts/pthreads-w32-2-9-1-release/Pre-built.2/include
    #IMPORTED_LOCATION D:/artifacts/pthreads-w32-2-9-1-release/Pre-built.2/dll/x64/pthreadVC2.dll
    IMPORTED_IMPLIB D:/artifacts/pthreads-w32-2-9-1-release/Pre-built.2/lib/x64/pthreadVC2.lib
)
target_compile_definitions(win_pthread INTERFACE _TIMESPEC_DEFINED)
