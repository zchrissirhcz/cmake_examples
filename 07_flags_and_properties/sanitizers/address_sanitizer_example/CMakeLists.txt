cmake_minimum_required(VERSION 3.15)

project(demo)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)


include(../asan.cmake)

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
