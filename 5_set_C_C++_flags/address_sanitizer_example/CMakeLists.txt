cmake_minimum_required(VERSION 3.15)

project(demo)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

option(USE_ASAN "Use Address Sanitizer?" ON)
#--------------------------------------------------
# globally setting
#--------------------------------------------------
# https://stackoverflow.com/a/65019152/2999096
if(USE_ASAN)
  if (MSVC)
    message(WARNING "AddressSanitizer for MSVC must be enabled manually in project's property page.")
  else()
    message(STATUS ">>> USE_ASAN: YES")
    message(STATUS ">>> CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
    if (CMAKE_BUILD_TYPE MATCHES "Debug")
      message(STATUS ">>>!!!!!!!!!!!Debug mode")
      # On debug mode
      set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_LINKER_FLAGS_DEBUG "${CMAKE_LINKER_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")
    elseif (CMAKE_BUILD_TYPE MATCHES "Release")
      # Note: `-g` is explicitly required here, even if NDK android.toolchain.cmake's `-g` exists.
      set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_LINKER_FLAGS_RELEASE "${CMAKE_LINKER_FLAGS_RELEASE} -g -fno-omit-frame-pointer -fsanitize=address")
    elseif (CMAKE_BUILD_TYPE MATCHES "RelWithDebInfo")
      set(CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_LINKER_FLAGS_RELWITHDEBINFO} -g -fno-omit-frame-pointer -fsanitize=address")
    elseif (CMAKE_BUILD_TYPE MATCHES "MinSizeRel")
      set(CMAKE_C_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_LINKER_FLAGS_MINSIZEREL "${CMAKE_LINKER_FLAGS_MINSIZEREL} -g -fno-omit-frame-pointer -fsanitize=address")
    elseif (CMAKE_BUILD_TYPE EQUAL "None" OR NOT CMAKE_BUILD_TYPE)
      set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_LINKER_FLAGS "${CMAKE_LINKER_FLAGS} -g -fno-omit-frame-pointer -fsanitize=address")
    endif()
  endif()
else()
  message(STATUS ">>> USE_ASAN: NO")
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
