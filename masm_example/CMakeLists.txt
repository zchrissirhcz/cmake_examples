cmake_minimum_required(VERSION 3.15)

project(demo)

if(NOT MSVC)
    message(FATAL_ERROR "This demo only works on Visual Studio")
endif()

enable_language(ASM_MASM)

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /SAFESEH:NO /NODEFAULTLIB:LIBC.LIB")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /SAFESEH:NO /NODEFAULTLIB:LIBC.LIB")
set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} /SAFESEH:NO /NODEFAULTLIB:LIBC.LIB")

add_executable(demo
    src/main.cpp
    src/CalcSum_.asm
)

