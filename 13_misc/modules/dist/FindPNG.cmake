# Practical PNG find script
# Copyright (c) 2020 by Zhuo Zhang

#[=======================================================================[.rst:
FindPNG
-------

Find libpng, the official reference library for the PNG image format.

Imported targets
^^^^^^^^^^^^^^^^

This module defines the following :prop_tgt:`IMPORTED` target:

``PNG::PNG``
  The libpng library, if found.

Result variables
^^^^^^^^^^^^^^^^

This module will set the following variables in your project:

``PNG_INCLUDE_DIRS``
  where to find png.h, etc.
``PNG_LIBRARIES``
  the libraries to link against to use PNG.
``PNG_DEFINITIONS``
  You should add_definitions(${PNG_DEFINITIONS}) before compiling code
  that includes png library files.
``PNG_FOUND``
  If false, do not try to use PNG.
``PNG_VERSION_STRING``
  the version of the PNG library found (since CMake 2.8.8)

Obsolete variables
^^^^^^^^^^^^^^^^^^

The following variables may also be set, for backwards compatibility:

``PNG_LIBRARY``
  where to find the PNG library.
``PNG_INCLUDE_DIR``
  where to find the PNG headers (same as PNG_INCLUDE_DIRS)

Since PNG depends on the ZLib compression library, none of the above
will be defined unless ZLib can be found.


Hints
^^^^^

A user may use these variables before `find_package(PNG)`:

PNG_ROOT

PNG_USE_STATIC_LIBS

PNG_DLL


Example
^^^^^^^
```cmake
# set PNG_ROOT (optional)
set(PNG_ROOT "/home/zz/soft/libpng" CACHE PATH "")

# find package
find_package(PNG REQUIRED)

add_executable(demo src/demo.cpp)

# linke png
target_link_libraries(demo PNG::PNG)

# copy dll
if(MSVC AND NOT PNG_USE_STATIC_LIBS) # copy dll
    add_custom_command(TARGET demo
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${PNG_DLL}
        ${CMAKE_BINARY_DIR}/
    )
endif()
```
#]=======================================================================]

if(PNG_FIND_QUIETLY)
  set(_FIND_ZLIB_ARG QUIET)
endif()
find_package(ZLIB ${_FIND_ZLIB_ARG})

if(ZLIB_FOUND)
  set(_PNG_SEARCHES)
  if(PNG_ROOT)
    set(_PNG_SEARCH_ROOT PATHS ${PNG_ROOT} NO_DEFAULT_PATH)
    list(APPEND _PNG_SEARCHES _PNG_SEARCH_ROOT)
  endif()

  if(CMAKE_SYSTEM_PROCESSOR MATCHES "^(arm|aarch64)")
    set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY BOTH)
    set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE BOTH)
    set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE BOTH)
  endif()

  foreach(search ${_PNG_SEARCHES})
    find_path(PNG_PNG_INCLUDE_DIR NAMES png.h ${${search}} PATH_SUFFIXES include/libpng include)
  endforeach()
  find_path(PNG_PNG_INCLUDE_DIR NAMES png.h)

  list(APPEND PNG_NAMES png libpng)
  unset(PNG_NAMES_DEBUG)
  set(_PNG_VERSION_SUFFIXES 17 16 15 14 12)
  if(PNG_FIND_VERSION MATCHES "^([0-9]+)\\.([0-9]+)(\\..*)?$")
    set(_PNG_VERSION_SUFFIX_MIN "${CMAKE_MATCH_1}${CMAKE_MATCH_2}")
    if(PNG_FIND_VERSION_EXACT)
      set(_PNG_VERSION_SUFFIXES ${_PNG_VERSION_SUFFIX_MIN})
    else()
      string(REGEX REPLACE
          "${_PNG_VERSION_SUFFIX_MIN}.*" "${_PNG_VERSION_SUFFIX_MIN}"
          _PNG_VERSION_SUFFIXES "${_PNG_VERSION_SUFFIXES}")
    endif()
    unset(_PNG_VERSION_SUFFIX_MIN)
  endif()
  foreach(v IN LISTS _PNG_VERSION_SUFFIXES)
    list(APPEND PNG_NAMES libpng${v}_static png${v} libpng${v})
    list(APPEND PNG_NAMES_DEBUG libpng${v}_staticd png${v}d libpng${v}d)
  endforeach()
  unset(_PNG_VERSION_SUFFIXES)
  # For compatibility with versions prior to this multi-config search, honor
  # any PNG_LIBRARY that is already specified and skip the search.
  if(NOT PNG_LIBRARY)
    if(MSVC)
      if(PNG_USE_STATIC_LIBS)
        set(_png_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
        # find .lib
        set(CMAKE_FIND_LIBRARY_SUFFIXES .lib)
        foreach(search ${_PNG_SEARCHES})
          find_library(PNG_LIBRARY_RELEASE NAMES ${PNG_NAMES} NAMES_PER_DIR ${${search}} PATH_SUFFIXES lib)
          find_library(PNG_LIBRARY_DEBUG NAMES ${PNG_NAMES_DEBUG} NAMES_PER_DIR ${${search}} PATH_SUFFIXES lib)
        endforeach()
        set(CMAKE_FIND_LIBRARY_SUFFIXES ${_png_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
      else()
        set(_png_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
        # find .lib
        set(CMAKE_FIND_LIBRARY_SUFFIXES .lib)
        find_library(PNG_IMPLIB_RELEASE NAMES ${PNG_NAMES})
        find_library(PNG_IMPLIB_DEBUG NAMES ${PNG_NAMES_DEBUG})
        # find .dll
        set(CMAKE_FIND_LIBRARY_SUFFIXES .dll)
        find_library(PNG_LIBRARY_RELEASE NAMES ${PNG_NAMES})
        find_library(PNG_LIBRARY_DEBUG NAMES ${PNG_NAMES_DEBUG})
        set(CMAKE_FIND_LIBRARY_SUFFIXES ${_png_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
      endif()
    elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
      if(PNG_USE_STATIC_LIBS)
        set(_png_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
        set(CMAKE_FIND_LIBRARY_SUFFIXES .a)
      endif()
      find_library(PNG_LIBRARY_RELEASE NAMES ${PNG_NAMES})
      find_library(PNG_LIBRARY_DEBUG NAMES ${PNG_NAMES_DEBUG})
      if(PNG_USE_STATIC_LIBS)
        set(CMAKE_FIND_LIBRARY_SUFFIXES ${_png_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
      endif()
    elseif(APPLE)
      set(_zlib_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
      if(PNG_USE_STATIC_LIBS)
        set(CMAKE_FIND_LIBRARY_SUFFIXES .a)
      else()
        set(CMAKE_FIND_LIBRARY_SUFFIXES .tbd .dylib .so)
      endif()
      find_library(PNG_LIBRARY_RELEASE NAMES ${PNG_NAMES})
      find_library(PNG_LIBRARY_DEBUG NAMES ${PNG_NAMES_DEBUG})
    endif()
    include(SelectLibraryConfigurations)
    select_library_configurations(PNG)
    mark_as_advanced(PNG_LIBRARY_RELEASE PNG_LIBRARY_DEBUG)
  endif()
  unset(PNG_NAMES)
  unset(PNG_NAMES_DEBUG)

  # Set by select_library_configurations(), but we want the one from
  # find_package_handle_standard_args() below.
  unset(PNG_FOUND)

  if(PNG_LIBRARY AND PNG_PNG_INCLUDE_DIR)
      # png.h includes zlib.h. Sigh.
      set(PNG_INCLUDE_DIRS ${PNG_PNG_INCLUDE_DIR} ${ZLIB_INCLUDE_DIR} )
      set(PNG_INCLUDE_DIR ${PNG_INCLUDE_DIRS} ) # for backward compatibility
      set(PNG_LIBRARIES ${PNG_LIBRARY} ${ZLIB_LIBRARY})
      if((CMAKE_SYSTEM_NAME STREQUAL "Linux") AND
         ("${PNG_LIBRARY}" MATCHES "\\${CMAKE_STATIC_LIBRARY_SUFFIX}$"))
        list(APPEND PNG_LIBRARIES m)
      endif()

      if(CYGWIN)
        if(BUILD_SHARED_LIBS)
           # No need to define PNG_USE_DLL here, because it's default for Cygwin.
        else()
          set(PNG_DEFINITIONS -DPNG_STATIC)
          set(_PNG_COMPILE_DEFINITIONS PNG_STATIC)
        endif()
      endif()

      if(NOT TARGET PNG::PNG)
        if(MSVC)
          if(PNG_USE_STATIC_LIBS)
            add_library(PNG::PNG STATIC IMPORTED)
            set_target_properties(PNG::PNG PROPERTIES
              INTERFACE_COMPILE_DEFINITIONS "${_PNG_COMPILE_DEFINITIONS}"
              INTERFACE_INCLUDE_DIRECTORIES "${PNG_INCLUDE_DIRS}"
              INTERFACE_LINK_LIBRARIES ZLIB::ZLIB

              IMPORTED_LOCATION_DEBUG "${PNG_LIBRARY_DEBUG}"
              IMPORTED_LOCATION_RELEASE "${PNG_LIBRARY_RELEASE}"
        
              MAP_IMPORTED_CONFIG_MINSIZEREL Release
              MAP_IMPORTED_CONFIG_RELWITHDEBINFO Release
            )
          else()
            add_library(PNG::PNG SHARED IMPORTED)
            set_target_properties(PNG::PNG PROPERTIES
              INTERFACE_COMPILE_DEFINITIONS "${_PNG_COMPILE_DEFINITIONS}"
              INTERFACE_INCLUDE_DIRECTORIES "${PNG_INCLUDE_DIRS}"
              INTERFACE_LINK_LIBRARIES ZLIB::ZLIB

              IMPORTED_IMPLIB_DEBUG "${PNG_IMPLIB_DEBUG}"
              IMPORTED_IMPLIB_RELEASE "${PNG_IMPLIB_RELEASE}"

              IMPORTED_LOCATION_DEBUG "${PNG_LIBRARY_DEBUG}"
              IMPORTED_LOCATION_RELEASE "${PNG_LIBRARY_RELEASE}"
        
              MAP_IMPORTED_CONFIG_MINSIZEREL Release
              MAP_IMPORTED_CONFIG_RELWITHDEBINFO Release
            )
            get_target_property(PNG_DEBUG_DLL PNG::PNG IMPORTED_LOCATION_DEBUG)
            get_target_property(PNG_RELEASE_DLL PNG::PNG IMPORTED_LOCATION_RELEASE)
            set(PNG_DLL
              $<$<CONFIG:Debug>:"${PNG_DEBUG_DLL}">
              $<$<CONFIG:Release>:"${PNG_RELEASE_DLL}">
              $<$<CONFIG:MinSizeRel>:"${PNG_RELEASE_DLL}">
              $<$<CONFIG:RelWithDebInfo>:"${PNG_RELEASE_DLL}">
            )
          endif()
        else()
          add_library(PNG::PNG UNKNOWN IMPORTED)
          set_target_properties(PNG::PNG PROPERTIES
            INTERFACE_COMPILE_DEFINITIONS "${_PNG_COMPILE_DEFINITIONS}"
            INTERFACE_INCLUDE_DIRECTORIES "${PNG_INCLUDE_DIRS}"
            INTERFACE_LINK_LIBRARIES ZLIB::ZLIB)
          if((CMAKE_SYSTEM_NAME STREQUAL "Linux") AND
            ("${PNG_LIBRARY}" MATCHES "\\${CMAKE_STATIC_LIBRARY_SUFFIX}$"))
            set_property(TARGET PNG::PNG APPEND PROPERTY
              INTERFACE_LINK_LIBRARIES m)
          endif()

          if(EXISTS "${PNG_LIBRARY}")
            set_target_properties(PNG::PNG PROPERTIES
              IMPORTED_LINK_INTERFACE_LANGUAGES "C"
              IMPORTED_LOCATION "${PNG_LIBRARY}")
          endif()
          if(EXISTS "${PNG_LIBRARY_RELEASE}")
            set_property(TARGET PNG::PNG APPEND PROPERTY
              IMPORTED_CONFIGURATIONS RELEASE)
            set_target_properties(PNG::PNG PROPERTIES
              IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
              IMPORTED_LOCATION_RELEASE "${PNG_LIBRARY_RELEASE}")
          endif()
          if(EXISTS "${PNG_LIBRARY_DEBUG}")
            set_property(TARGET PNG::PNG APPEND PROPERTY
              IMPORTED_CONFIGURATIONS DEBUG)
            set_target_properties(PNG::PNG PROPERTIES
              IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "C"
              IMPORTED_LOCATION_DEBUG "${PNG_LIBRARY_DEBUG}")
          endif()
        endif()
      endif()

      unset(_PNG_COMPILE_DEFINITIONS)
  endif()

  if(PNG_PNG_INCLUDE_DIR AND EXISTS "${PNG_PNG_INCLUDE_DIR}/png.h")
      file(STRINGS "${PNG_PNG_INCLUDE_DIR}/png.h" png_version_str REGEX "^#define[ \t]+PNG_LIBPNG_VER_STRING[ \t]+\".+\"")

      string(REGEX REPLACE "^#define[ \t]+PNG_LIBPNG_VER_STRING[ \t]+\"([^\"]+)\".*" "\\1" PNG_VERSION_STRING "${png_version_str}")
      unset(png_version_str)
  endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PNG
                                  REQUIRED_VARS PNG_LIBRARY PNG_PNG_INCLUDE_DIR
                                  VERSION_VAR PNG_VERSION_STRING)

mark_as_advanced(PNG_PNG_INCLUDE_DIR PNG_LIBRARY )
