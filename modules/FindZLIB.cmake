# Practical ZLIB find script
# Copyright (c) 2020 by Zhuo Zhang
#
#[=======================================================================[.rst:
FindZLIB
--------

Find the native ZLIB includes and library.

IMPORTED Targets
^^^^^^^^^^^^^^^^

This module defines :prop_tgt:`IMPORTED` target ``ZLIB``, if
ZLIB has been found.

Result Variables
^^^^^^^^^^^^^^^^

This module defines the following variables:

::

  ZLIB_INCLUDE_DIR    - Where to find zlib.h & zconf.h.
  ZLIB_LIBRARY_DIR    - Where to find zlib.lib, zlibstatic.lib, etc.
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

A user may set ``ZLIB_DIR`` to a zlib installation root to tell this
module where to look, or passing the following 3 vars:
- ``ZLIB_INCLUDE_DIR``
- ``ZLIB_BINARY_DIR``
- ``ZLIB_LIBRARY_DIR``

Optinally, people can choose using shared or static library by passing
``ZLIB_SHARED`` (ON/OFF)

Example
^^^^^^^
```
set(ZLIB_DIR "D:/lib/zlib/1.2.11/x64/vc15" CACHE PATH "")
find_package(ZLIB)

add_executable(demo src/demo.cpp)
target_link_libraries(demo ZLIB)

if(MSVC AND ZLIB_SHARED)
  add_custom_command(TARGET demo
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    ${ZLIB_DEBUG_DLL}
    ${CMAKE_BINARY_DIR}/
  )
  add_custom_command(TARGET demo
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    ${ZLIB_RELEASE_DLL}
    ${CMAKE_BINARY_DIR}/
  )
endif()
```
#]=======================================================================]

include(FindPackageHandleStandardArgs)

set(ZLIB_DIR "D:/lib/zlib/1.2.11/x64/vc15" CACHE PATH "ZLIB install directory")
set(ZLIB_INCLUDE_DIR "${ZLIB_DIR}/include" CACHE PATH "ZLIB include directory")
set(ZLIB_BINARY_DIR "${ZLIB_DIR}/bin" CACHE PATH "ZLIB binary directory")
set(ZLIB_LIBRARY_DIR "${ZLIB_DIR}/lib" CACHE PATH "ZLIB library directory")

set(ZLIB_SHARED OFF CACHE BOOLEAN "Use shared library or not?")


# TODO: validate ZLIB_INCLUDE_DIR, ZLIB_BINARY_DIR, ZLIB_LIBRARY_DIR
# TODO: consider Linux/MacOSX situation
# TODO: determine and set version related variables


if(ZLIB_SHARED)
  add_library(ZLIB SHARED IMPORTED)
else()
  add_library(ZLIB STATIC IMPORTED)
endif()

if(ZLIB_SHARED)
  set_target_properties(ZLIB PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${ZLIB_INCLUDE_DIR}"
    IMPORTED_IMPLIB_DEBUG "${ZLIB_LIBRARY_DIR}/zlibd.lib"
    IMPORTED_IMPLIB_RELEASE "${ZLIB_LIBRARY_DIR}/zlib.lib"

    IMPORTED_LOCATION_DEBUG "${ZLIB_BINARY_DIR}/zlibd.dll"
    IMPORTED_LOCATION_RELEASE "${ZLIB_BINARY_DIR}/zlib.dll"

    MAP_IMPORTED_CONFIG_MINSIZEREL Release
    MAP_IMPORTED_CONFIG_RELWITHDEBINFO Release
  )
else()
  set_target_properties(ZLIB PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${ZLIB_INCLUDE_DIR}"
    IMPORTED_LOCATION_DEBUG "${ZLIB_LIBRARY_DIR}/zlibstaticd.lib"
    IMPORTED_LOCATION_RELEASE "${ZLIB_LIBRARY_DIR}/zlibstatic.lib"

    MAP_IMPORTED_CONFIG_MINSIZEREL Release
    MAP_IMPORTED_CONFIG_RELWITHDEBINFO Release
  )
endif()
