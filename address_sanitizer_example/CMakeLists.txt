cmake_minimum_required(VERSION 3.15)

project(demo)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

option(USE_ASAN "use asan?" ON)
#--------------------------------------------------
# globally setting
#--------------------------------------------------
# https://stackoverflow.com/a/65019152/2999096
if(USE_ASAN)
    # if you'd like to use Debug mode
    set(CMAKE_BUILD_TYPE "Debug")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")
    set(CMAKE_LINKER_FLAGS_DEBUG "${CMAKE_LINKER_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")

    # you may also use ASan under Release mode
    # Note: `-g` is explicitly required here, even if NDK android.toolchain.cmake's `-g` exists.
    set(CMAKE_BUILD_TYPE "Release")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS_DEBUG} -g -fno-omit-frame-pointer -fsanitize=address")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS_DEBUG} -g -fno-omit-frame-pointer -fsanitize=address")
    set(CMAKE_LINKER_FLAGS "${CMAKE_LINKER_FLAGS_DEBUG} -g -fno-omit-frame-pointer -fsanitize=address")
endif()

# foreach(NAME CMAKE_EXE_LINKER_FLAGS CMAKE_MODULE_LINKER_FLAGS CMAKE_SHARED_LINKER_FLAGS)
#   set(${NAME} "-fsanitize=address ${${NAME}}")
# endforeach()

#--------------------------------------------------
# single target setting
#--------------------------------------------------
# set_target_properties(<project-name> PROPERTIES
#   COMPILE_FLAGS "-fsanitize=address -fno-omit-frame-pointer"
#   LINK_FLAGS "-fsanitize=address"
# )

#--------------------------------------------------
# makefile setting
#--------------------------------------------------
# CFLAGS += -fsanitize=address -fno-omit-frame-pointer
# CXXFLAGS += -fsanitize=address -fno-omit-frame-pointer
# LDFLAGS += -fsanitize=address

add_executable(demo
    src/main.c
    src/my_alloc.c
)

add_executable(demo2
    src/char_array.c
)
