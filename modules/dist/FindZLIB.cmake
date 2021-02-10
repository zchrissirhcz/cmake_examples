# Practical ZLIB find script
# Copyright (c) 2020 by Zhuo Zhang

#[=======================================================================[.rst:
FindZLIB
--------

Find the native ZLIB includes and library.

HIGHLIGHTS
^^^^^^^^^^
Support using static lib, support windows (including dll).

IMPORTED Targets
^^^^^^^^^^^^^^^^

This module defines :prop_tgt:`IMPORTED` target ``ZLIB::ZLIB``, if
ZLIB has been found.

Result Variables
^^^^^^^^^^^^^^^^

This module defines the following variables:

::

  ZLIB_INCLUDE_DIRS   - where to find zlib.h, etc.
  ZLIB_LIBRARIES      - List of libraries when using zlib.
  ZLIB_FOUND          - True if zlib found.

::

  ZLIB_VERSION_STRING - The version of zlib found (x.y.z)
  ZLIB_VERSION_MAJOR  - The major version of zlib
  ZLIB_VERSION_MINOR  - The minor version of zlib
  ZLIB_VERSION_PATCH  - The patch version of zlib
  ZLIB_VERSION_TWEAK  - The tweak version of zlib

Backward Compatibility
^^^^^^^^^^^^^^^^^^^^^^

The following variable are provided for backward compatibility

::

  ZLIB_MAJOR_VERSION  - The major version of zlib
  ZLIB_MINOR_VERSION  - The minor version of zlib
  ZLIB_PATCH_VERSION  - The patch version of zlib

Hints
^^^^^

A user may set these varaibles before `find_package(ZLIB)`:

ZLIB_ROOT             - Set to a zlib installation root to tell this module where to look

ZLIB_USE_STATIC_LIBS  - Set to ON to force the use of the static libraries.
                        Default is OFF
ZLIB_DLL              - zlib's dll absolute path when on MSVC with ZLIB_USE_STATIC_LIBS=OFF


Example
^^^^^^^
```cmake
# set ZLIB_ROOT (optional)
set(ZLIB_ROOT "/home/zz/soft/zlib/1.2.11" CACHE PATH "")

# set ZLIB_USE_STATIC_LIBS (optional)
set(ZLIB_USE_STATIC_LIBS ON)

# find ZLIB
find_package(ZLIB REQUIRED)

add_executable(demo src/demo.cpp)

target_link_libraries(demo ZLIB::ZLIB)

# copy dlls if necessary
if(MSVC AND NOT ZLIB_USE_STATIC_LIBS)
  add_custom_command(TARGET demo
      POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E copy_if_different
      ${ZLIB_DLL}
      ${CMAKE_BINARY_DIR}/
  )
endif()

# to diagnose zlib
message(STATUS "--- ZLIB_INCLUDE_DIRS is: ${ZLIB_INCLUDE_DIRS}")
message(STATUS "--- ZLIB_LIBRARIES is: ${ZLIB_LIBRARIES}")
message(STATUS "--- ZLIB_VERSION_STRING: ${ZLIB_VERSION_STRING}")
```
#]=======================================================================]

set(_ZLIB_SEARCHES)

# Search ZLIB_ROOT first if it is set.
if(ZLIB_ROOT)
  set(_ZLIB_SEARCH_ROOT PATHS ${ZLIB_ROOT} NO_DEFAULT_PATH)
  list(APPEND _ZLIB_SEARCHES _ZLIB_SEARCH_ROOT)
endif()

if(CMAKE_SYSTEM_PROCESSOR MATCHES "^(arm|aarch64)")
    set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY BOTH)
    set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE BOTH)
    set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE BOTH)
endif()

# Normal search.
set(_ZLIB_x86 "(x86)")
set(_ZLIB_SEARCH_NORMAL
    PATHS "[HKEY_LOCAL_MACHINE\\SOFTWARE\\GnuWin32\\Zlib;InstallPath]"
          "$ENV{ProgramFiles}/zlib"
          "$ENV{ProgramFiles${_ZLIB_x86}}/zlib"
)
unset(_ZLIB_x86)
list(APPEND _ZLIB_SEARCHES ${_ZLIB_SEARCH_NORMAL})

set(ZLIB_NAMES z zlib zdll zlib1 zlibstatic)
set(ZLIB_NAMES_DEBUG zd zlibd zdlld zlibd1 zlib1d zlibstaticd)

# Try each search configuration.
foreach(search ${_ZLIB_SEARCHES})
  find_path(ZLIB_INCLUDE_DIR NAMES zlib.h ${${search}} PATH_SUFFIXES include)
endforeach()

# Allow ZLIB_LIBRARY to be set manually, as the location of the zlib library
if(NOT ZLIB_LIBRARY)

  if(MSVC)
    if(ZLIB_USE_STATIC_LIBS)
      set(_zlib_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
      # find .lib
      set(CMAKE_FIND_LIBRARY_SUFFIXES .lib)
      foreach(search ${_ZLIB_SEARCHES})
        find_library(ZLIB_LIBRARY_RELEASE NAMES zlibstatic NAMES_PER_DIR ${${search}} PATH_SUFFIXES lib)
        find_library(ZLIB_LIBRARY_DEBUG NAMES zlibstaticd NAMES_PER_DIR ${${search}} PATH_SUFFIXES lib)
      endforeach()
      set(CMAKE_FIND_LIBRARY_SUFFIXES ${_zlib_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
    else()
      set(_zlib_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
      # find .lib
      set(CMAKE_FIND_LIBRARY_SUFFIXES .lib)
      foreach(search ${_ZLIB_SEARCHES})
        find_library(ZLIB_IMPLIB_RELEASE NAMES zlib NAMES_PER_DIR ${${search}} PATH_SUFFIXES lib)
        find_library(ZLIB_IMPLIB_DEBUG NAMES zlibd zlib NAMES_PER_DIR ${${search}} PATH_SUFFIXES lib)
      endforeach()
      # find .dll
      set(CMAKE_FIND_LIBRARY_SUFFIXES .dll)
      foreach(search ${_ZLIB_SEARCHES})
        find_library(ZLIB_LIBRARY_RELEASE NAMES zlib NAMES_PER_DIR ${${search}} PATH_SUFFIXES bin)
        find_library(ZLIB_LIBRARY_DEBUG NAMES zlibd zlib NAMES_PER_DIR ${${search}} PATH_SUFFIXES bin)
      endforeach()
      set(CMAKE_FIND_LIBRARY_SUFFIXES ${_zlib_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
    endif()
  elseif(CMAKE_SYSTEM_NAME MATCHES "Linux" OR ANDROID)
    set(_zlib_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
    if(ZLIB_USE_STATIC_LIBS)
      set(CMAKE_FIND_LIBRARY_SUFFIXES .a)
    else()
      set(CMAKE_FIND_LIBRARY_SUFFIXES .so)
    endif()
    foreach(search ${_ZLIB_SEARCHES})
      find_library(ZLIB_LIBRARY_RELEASE NAMES ${ZLIB_NAMES} NAMES_PER_DIR ${${search}})
      find_library(ZLIB_LIBRARY_DEBUG NAMES ${ZLIB_NAMES_DEBUG} NAMES_PER_DIR ${${search}})
    endforeach()
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${_zlib_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
  elseif(APPLE)
    set(_zlib_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
    if(ZLIB_USE_STATIC_LIBS)
      set(CMAKE_FIND_LIBRARY_SUFFIXES .a)
    else()
      set(CMAKE_FIND_LIBRARY_SUFFIXES .tbd .dylib .so)
    endif()
    foreach(search ${_ZLIB_SEARCHES})
      find_library(ZLIB_LIBRARY_RELEASE NAMES ${ZLIB_NAMES} NAMES_PER_DIR ${${search}} PATH_SUFFIXES lib)
      find_library(ZLIB_LIBRARY_DEBUG NAMES ${ZLIB_NAMES_DEBUG} NAMES_PER_DIR ${${search}} PATH_SUFFIXES lib)
    endforeach()
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${_zlib_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
  else()
    message(FATAL_ERROR "----!!! not implemented yet")
  endif()

  include(SelectLibraryConfigurations)
  select_library_configurations(ZLIB)
endif()

unset(ZLIB_NAMES)
unset(ZLIB_NAMES_DEBUG)

mark_as_advanced(ZLIB_INCLUDE_DIR)

if(ZLIB_INCLUDE_DIR AND EXISTS "${ZLIB_INCLUDE_DIR}/zlib.h")
    file(STRINGS "${ZLIB_INCLUDE_DIR}/zlib.h" ZLIB_H REGEX "^#define ZLIB_VERSION \"[^\"]*\"$")

    string(REGEX REPLACE "^.*ZLIB_VERSION \"([0-9]+).*$" "\\1" ZLIB_VERSION_MAJOR "${ZLIB_H}")
    string(REGEX REPLACE "^.*ZLIB_VERSION \"[0-9]+\\.([0-9]+).*$" "\\1" ZLIB_VERSION_MINOR  "${ZLIB_H}")
    string(REGEX REPLACE "^.*ZLIB_VERSION \"[0-9]+\\.[0-9]+\\.([0-9]+).*$" "\\1" ZLIB_VERSION_PATCH "${ZLIB_H}")
    set(ZLIB_VERSION_STRING "${ZLIB_VERSION_MAJOR}.${ZLIB_VERSION_MINOR}.${ZLIB_VERSION_PATCH}")

    # only append a TWEAK version if it exists:
    set(ZLIB_VERSION_TWEAK "")
    if( "${ZLIB_H}" MATCHES "ZLIB_VERSION \"[0-9]+\\.[0-9]+\\.[0-9]+\\.([0-9]+)")
        set(ZLIB_VERSION_TWEAK "${CMAKE_MATCH_1}")
        string(APPEND ZLIB_VERSION_STRING ".${ZLIB_VERSION_TWEAK}")
    endif()

    set(ZLIB_MAJOR_VERSION "${ZLIB_VERSION_MAJOR}")
    set(ZLIB_MINOR_VERSION "${ZLIB_VERSION_MINOR}")
    set(ZLIB_PATCH_VERSION "${ZLIB_VERSION_PATCH}")
endif()

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(ZLIB REQUIRED_VARS ZLIB_LIBRARY ZLIB_INCLUDE_DIR
                                       VERSION_VAR ZLIB_VERSION_STRING)

if(ZLIB_FOUND)
    set(ZLIB_INCLUDE_DIRS ${ZLIB_INCLUDE_DIR})

    if(NOT ZLIB_LIBRARIES)
      set(ZLIB_LIBRARIES ${ZLIB_LIBRARY})
    endif()

    if(NOT TARGET ZLIB::ZLIB)
      if(MSVC)
        if(ZLIB_USE_STATIC_LIBS)
          add_library(ZLIB::ZLIB STATIC IMPORTED)
          set_target_properties(ZLIB::ZLIB PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${ZLIB_INCLUDE_DIRS}"
            IMPORTED_LOCATION_DEBUG "${ZLIB_LIBRARY_DEBUG}"
            IMPORTED_LOCATION_RELEASE "${ZLIB_LIBRARY_RELEASE}"
      
            MAP_IMPORTED_CONFIG_MINSIZEREL Release
            MAP_IMPORTED_CONFIG_RELWITHDEBINFO Release
          )
        else()
          add_library(ZLIB::ZLIB SHARED IMPORTED)
          set_target_properties(ZLIB::ZLIB PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${ZLIB_INCLUDE_DIRS}"
            IMPORTED_IMPLIB_DEBUG "${ZLIB_IMPLIB_DEBUG}"
            IMPORTED_IMPLIB_RELEASE "${ZLIB_IMPLIB_RELEASE}"
      
            IMPORTED_LOCATION_DEBUG "${ZLIB_LIBRARY_DEBUG}"
            IMPORTED_LOCATION_RELEASE "${ZLIB_LIBRARY_RELEASE}"
      
            MAP_IMPORTED_CONFIG_MINSIZEREL Release
            MAP_IMPORTED_CONFIG_RELWITHDEBINFO Release
          )
          get_target_property(ZLIB_DEBUG_DLL ZLIB::ZLIB IMPORTED_LOCATION_DEBUG)
          get_target_property(ZLIB_RELEASE_DLL ZLIB::ZLIB IMPORTED_LOCATION_RELEASE)
          set(ZLIB_DLL
            $<$<CONFIG:Debug>:"${ZLIB_DEBUG_DLL}">
            $<$<CONFIG:Release>:"${ZLIB_RELEASE_DLL}">
            $<$<CONFIG:MinSizeRel>:"${ZLIB_RELEASE_DLL}">
            $<$<CONFIG:RelWithDebInfo>:"${ZLIB_RELEASE_DLL}">
          )
        endif()
      else()
        add_library(ZLIB::ZLIB UNKNOWN IMPORTED)
        set_target_properties(ZLIB::ZLIB PROPERTIES
          INTERFACE_INCLUDE_DIRECTORIES "${ZLIB_INCLUDE_DIRS}")

        if(ZLIB_LIBRARY_RELEASE)
          set_property(TARGET ZLIB::ZLIB APPEND PROPERTY
            IMPORTED_CONFIGURATIONS RELEASE)
          set_target_properties(ZLIB::ZLIB PROPERTIES
            IMPORTED_LOCATION_RELEASE "${ZLIB_LIBRARY_RELEASE}")
        endif()

        if(ZLIB_LIBRARY_DEBUG)
          set_property(TARGET ZLIB::ZLIB APPEND PROPERTY
            IMPORTED_CONFIGURATIONS DEBUG)
          set_target_properties(ZLIB::ZLIB PROPERTIES
            IMPORTED_LOCATION_DEBUG "${ZLIB_LIBRARY_DEBUG}")
        endif()

        if(NOT ZLIB_LIBRARY_RELEASE AND NOT ZLIB_LIBRARY_DEBUG)
          set_property(TARGET ZLIB::ZLIB APPEND PROPERTY
            IMPORTED_LOCATION "${ZLIB_LIBRARY}")
        endif()
      endif()
    endif()
endif()
