# Practical JPEG find script
# Copyright (c) 2020 by Zhuo Zhang

#[=======================================================================[.rst:
FindJPEG
--------

Find the Joint Photographic Experts Group (JPEG) library (``libjpeg``)

Imported targets
^^^^^^^^^^^^^^^^

This module defines the following :prop_tgt:`IMPORTED` targets:

``JPEG::JPEG``
  The JPEG library, if found.

Result variables
^^^^^^^^^^^^^^^^

This module will set the following variables in your project:

``JPEG_FOUND``
  If false, do not try to use JPEG.
``JPEG_INCLUDE_DIRS``
  where to find jpeglib.h, etc.
``JPEG_LIBRARIES``
  the libraries needed to use JPEG.
``JPEG_VERSION``
  the version of the JPEG library found

Cache variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``JPEG_INCLUDE_DIRS``
  where to find jpeglib.h, etc.
``JPEG_LIBRARY_RELEASE``
  where to find the JPEG library (optimized).
``JPEG_LIBRARY_DEBUG``
  where to find the JPEG library (debug).

Obsolete variables
^^^^^^^^^^^^^^^^^^

``JPEG_INCLUDE_DIR``
  where to find jpeglib.h, etc. (same as JPEG_INCLUDE_DIRS)
``JPEG_LIBRARY``
  where to find the JPEG library.

Hint
^^^^

A user may use these variables before `find_package(PNG)`:

JPEG_ROOT

JPEG_USE_STATIC_LIBS

JPEG_DLL


Example
^^^^^^^
```cmake
# set JPEG_ROOT (optional)
set(JPEG_ROOT "E:/lib/libjpeg/x64/vc15" CACHE PATH "")

# find package
find_package(JPEG REQUIRED)

add_executable(demo src/demo.cpp)

# linke jpeg
target_link_libraries(demo JPEG::JPEG)

# copy dll
if(MSVC AND NOT JPEG_USE_STATIC_LIBS) # copy dll
    add_custom_command(TARGET demo
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${JPEG_DLL}
        ${CMAKE_BINARY_DIR}/
    )
endif()


Note
^^^^

It's not recommended to use libjpeg anymore since it is not maintained.
If you insist on, you may try my fork: https://github.com/zchrissirhcz/libjpeg/tree/fix_windows_build
which is with better cmake build support (especifally for window).
```

#]=======================================================================]

set(_JPEG_SEARCHES)

# Search JPEG_ROOT first if it is set.
if(JPEG_ROOT)
  set(_JPEG_SEARCH_ROOT PATHS ${JPEG_ROOT} NO_DEFAULT_PATH)
  list(APPEND _JPEG_SEARCHES _JPEG_SEARCH_ROOT)
endif()

foreach(search ${_JPEG_SEARCHES})
  find_path(JPEG_INCLUDE_DIR NAMES jpeglib.h 
    ${${search}} PATH_SUFFIXES include
  )
endforeach()
find_path(JPEG_INCLUDE_DIR NAMES jpeglib.h)

set(jpeg_names ${JPEG_NAMES} jpeg-static libjpeg-static jpeg libjpeg )
foreach(name ${jpeg_names})
  list(APPEND jpeg_names_debug "${name}d")
endforeach()

if(NOT JPEG_LIBRARY)
  if(MSVC)
    if(JPEG_USE_STATIC_LIBS)
      set(_jpeg_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
      # find .lib
      foreach(search ${_JPEG_SEARCHES})
        find_library(JPEG_LIBRARY_RELEASE NAMES jpeg_static jpeg-static libjpeg_static libjpeg-static
          NAMES_PER_DIR ${${search}} PATH_SUFFIXES lib)
        find_library(JPEG_LIBRARY_DEBUG NAMES jpeg_staticd jpeg-staticd libjpeg_staticd libjpeg-staticd
          NAMES_PER_DIR ${${search}} PATH_SUFFIXES lib)
      endforeach()
      set(CMAKE_FIND_LIBRARY_SUFFIXES ${_jpeg_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
    else()
      set(_jpeg_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
      # find .lib
      set(CMAKE_FIND_LIBRARY_SUFFIXES .lib)
      foreach(search ${_JPEG_SEARCHES})
        find_library(JPEG_IMPLIB_RELEASE NAMES jpeg libjpeg
          NAMES_PER_DIR ${${search}} PATH_SUFFIXES lib)
        find_library(JPEG_IMPLIB_DEBUG NAMES jpegd libjpegd
          NAMES_PER_DIR ${${search}} PATH_SUFFIXES lib)
      endforeach()
      # find .dll
      set(CMAKE_FIND_LIBRARY_SUFFIXES .dll)
      foreach(search ${_JPEG_SEARCHES})
        find_library(JPEG_LIBRARY_RELEASE NAMES jpeg libjpeg
          NAMES_PER_DIR ${${search}} PATH_SUFFIXES bin)
        find_library(JPEG_LIBRARY_DEBUG NAMES jpegd libjpegd
          NAMES_PER_DIR ${${search}} PATH_SUFFIXES bin)
      endforeach()
      set(CMAKE_FIND_LIBRARY_SUFFIXES ${_jpeg_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
    endif()
  elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
    if(JPEG_USE_STATIC_LIBS)
      set(_jpeg_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
      set(CMAKE_FIND_LIBRARY_SUFFIXES .a)
    endif()
    find_library(JPEG_LIBRARY_RELEASE NAMES ${jpeg_names})
    find_library(JPEG_LIBRARY_DEBUG NAMES ${jpeg_names_debug})
    if(JPEG_USE_STATIC_LIBS)
      set(CMAKE_FIND_LIBRARY_SUFFIXES ${_jpeg_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
    endif()
  elseif(APPLE)
    set(_jpeg_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FINND_LIBRARY_SUFFIXES})
    if(JPEG_USE_STATIC_LIBS)
      set(CMAKE_FIND_LIBRARY_SUFFIXES .a)
    else()
      set(CMAKE_FIND_LIBRARY_SUFFIXES .tbd .dylib .so)
    endif()

    find_library(JPEG_LIBRARY_RELEASE NAMES ${jpeg_names})
    find_library(JPEG_LIBRARY_DEBUG NAMES ${jpeg_names_debug})

    set(CMAKE_FIND_LIBRARY_SUFFIXES ${_jpeg_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
  endif()
  
  include(SelectLibraryConfigurations)
  select_library_configurations(JPEG)
  mark_as_advanced(JPEG_LIBRARY_RELEASE JPEG_LIBRARY_DEBUG)
endif()
unset(jpeg_names)
unset(jpeg_names_debug)

if(JPEG_INCLUDE_DIR)
  file(GLOB _JPEG_CONFIG_HEADERS_FEDORA "${JPEG_INCLUDE_DIR}/jconfig*.h")
  file(GLOB _JPEG_CONFIG_HEADERS_DEBIAN "${JPEG_INCLUDE_DIR}/*/jconfig.h")
  set(_JPEG_CONFIG_HEADERS
    "${JPEG_INCLUDE_DIR}/jpeglib.h"
    ${_JPEG_CONFIG_HEADERS_FEDORA}
    ${_JPEG_CONFIG_HEADERS_DEBIAN})
  foreach (_JPEG_CONFIG_HEADER IN LISTS _JPEG_CONFIG_HEADERS)
    if(NOT EXISTS "${_JPEG_CONFIG_HEADER}")
      continue ()
    endif()
    file(STRINGS "${_JPEG_CONFIG_HEADER}"
      jpeg_lib_version REGEX "^#define[\t ]+JPEG_LIB_VERSION[\t ]+.*")

    if(NOT jpeg_lib_version)
      continue ()
    endif()

    string(REGEX REPLACE "^#define[\t ]+JPEG_LIB_VERSION[\t ]+([0-9]+).*"
      "\\1" JPEG_VERSION "${jpeg_lib_version}")
    break ()
  endforeach ()
  unset(jpeg_lib_version)
  unset(_JPEG_CONFIG_HEADER)
  unset(_JPEG_CONFIG_HEADERS)
  unset(_JPEG_CONFIG_HEADERS_FEDORA)
  unset(_JPEG_CONFIG_HEADERS_DEBIAN)
endif()

#message(STATUS "--- JPEG_LIBRARY_DEBUG is: ${JPEG_LIBRARY_DEBUG}")
#message(STATUS "--- JPEG_LIBRARY_RELEASE is: ${JPEG_LIBRARY_RELEASE}")
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(JPEG
  REQUIRED_VARS JPEG_LIBRARY JPEG_INCLUDE_DIR
  VERSION_VAR JPEG_VERSION)

if(JPEG_FOUND)
  set(JPEG_LIBRARIES ${JPEG_LIBRARY})
  set(JPEG_INCLUDE_DIRS "${JPEG_INCLUDE_DIR}")

  if(NOT TARGET JPEG::JPEG)
    if(MSVC)
      if(JPEG_USE_STATIC_LIBS)
        add_library(JPEG::JPEG STATIC IMPORTED)
        set_target_properties(JPEG::JPEG PROPERTIES
          INTERFACE_INCLUDE_DIRECTORIES "${JPEG_INCLUDE_DIRS}"
          IMPORTED_LINK_INTERFACE_LANGUAGES "C"

          IMPORTED_LOCATION_DEBUG "${JPEG_LIBRARY_DEBUG}"
          IMPORTED_LOCATION_RELEASE "${JPEG_LIBRARY_RELEASE}"

          MAP_IMPORTED_CONFIG_MINSIZEREL Release
          MAP_IMPORTED_CONFIG_RELWITHDEBINFO Release
        )
      else()
        add_library(JPEG::JPEG SHARED IMPORTED)
        set_target_properties(JPEG::JPEG PROPERTIES
          INTERFACE_INCLUDE_DIRECTORIES "${JPEG_INCLUDE_DIRS}"
          IMPORTED_LINK_INTERFACE_LANGUAGES "C"

          IMPORTED_IMPLIB_DEBUG "${JPEG_IMPLIB_DEBUG}"
          IMPORTED_IMPLIB_RELEASE "${JPEG_IMPLIB_RELEASE}"

          IMPORTED_LOCATION_DEBUG "${JPEG_LIBRARY_DEBUG}"
          IMPORTED_LOCATION_RELEASE "${JPEG_LIBRARY_RELEASE}"

          MAP_IMPORTED_CONFIG_MINSIZEREL Release
          MAP_IMPORTED_CONFIG_RELWITHDEBINFO Release
        )
        get_target_property(JPEG_DEBUG_DLL JPEG::JPEG IMPORTED_LOCATION_DEBUG)
        get_target_property(JPEG_RELEASE_DLL JPEG::JPEG IMPORTED_LOCATION_RELEASE)
        set(JPEG_DLL
          $<$<CONFIG:Debug>:"${JPEG_DEBUG_DLL}">
          $<$<CONFIG:Release>:"${JPEG_RELEASE_DLL}">
          $<$<CONFIG:MinSizeRel>:"${JPEG_RELEASE_DLL}">
          $<$<CONFIG:RelWithDebInfo>:"${JPEG_RELEASE_DLL}">
        )
        endif()
    else()
      add_library(JPEG::JPEG UNKNOWN IMPORTED)
      if(JPEG_INCLUDE_DIRS)
        set_target_properties(JPEG::JPEG PROPERTIES
          INTERFACE_INCLUDE_DIRECTORIES "${JPEG_INCLUDE_DIRS}")
      endif()
      if(EXISTS "${JPEG_LIBRARY}")
        set_target_properties(JPEG::JPEG PROPERTIES
          IMPORTED_LINK_INTERFACE_LANGUAGES "C"
          IMPORTED_LOCATION "${JPEG_LIBRARY}")
      endif()
      if(EXISTS "${JPEG_LIBRARY_RELEASE}")
        set_property(TARGET JPEG::JPEG APPEND PROPERTY
          IMPORTED_CONFIGURATIONS RELEASE)
        set_target_properties(JPEG::JPEG PROPERTIES
          IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
          IMPORTED_LOCATION_RELEASE "${JPEG_LIBRARY_RELEASE}")
      endif()
      if(EXISTS "${JPEG_LIBRARY_DEBUG}")
        set_property(TARGET JPEG::JPEG APPEND PROPERTY
          IMPORTED_CONFIGURATIONS DEBUG)
        set_target_properties(JPEG::JPEG PROPERTIES
          IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "C"
          IMPORTED_LOCATION_DEBUG "${JPEG_LIBRARY_DEBUG}")
      endif()
    endif()
  endif()
endif()

mark_as_advanced(JPEG_LIBRARY JPEG_INCLUDE_DIR)
