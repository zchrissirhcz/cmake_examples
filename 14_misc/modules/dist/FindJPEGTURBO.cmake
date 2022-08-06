# Practical JPEGTURBO find script
# Copyright (c) 2020 by Zhuo Zhang

#[=======================================================================[.rst:
FindJPEG
--------

Example usage:
```cmake
# set JPEGTURBO_ROOT (optional)
set(JPEGTURBO_ROOT "E:/lib/libjpeg-turbo" CACHE PATH "")

# find package
find_package(JPEGTURBO REQUIRED)

add_executable(demo src/demo.cpp)

# linke jpeg
target_link_libraries(demo JPEGTURBO::JPEGTURBO)

# copy dll
if(MSVC AND NOT JPEGTURBO_USE_STATIC_LIBS) # copy dll
    add_custom_command(TARGET demo
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${JPEGTURBO_DLL}
        ${CMAKE_BINARY_DIR}/
    )
endif()
```

#]=======================================================================]


set(_JPEGTURBO_SEARCHES)

# Search JPEGTURBO_ROOT first if it is set.
if(JPEGTURBO_ROOT)
    set(_JPEGTURBO_SEARCH_ROOT PATHS ${JPEGTURBO_ROOT} NO_DEFAULT_PATH)
    list(APPEND _JPEGTURBO_SEARCHES _JPEGTURBO_SEARCH_ROOT)
endif()
message(STATUS "--- CMAKE_SYSTEM_NAME is: ${CMAKE_SYSTEM_NAME}")

# TODO: add normal search directories here

if(CMAKE_SYSTEM_PROCESSOR MATCHES "^(arm|aarch64)")
    set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY BOTH)
    set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE BOTH)
    set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE BOTH)
endif()

# Try each search configurations.
find_path(JPEGTURBO_INCLUDE_DIR NAMES turbojpeg.h HINTS ${_JPEGTURBO_SEARCHES} PATH_SUFFIXES include)

# Allow JPEGTURBO_LIBRARY to be set manually, as the location of the jpeg-turbo library
if(NOT JPEGTURBO_LIBRARY)
    if(MSVC)
        if(JPEGTURBO_USE_STATIC_LIBS)
            set(_jpegturbo_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
            # find .lib
            set(CMAKE_FIND_LIBRARY_SUFFIXES .lib)
            find_library(JPEGTURBO_LIBRARY_RELEASE NAMES turbojpeg-static)
            find_library(JPEGTURBO_LIBRARY_DEBUG   NAMES turbojpeg-staticd turbojpeg-static)
            set(CMAKE_FIND_LIBRARY_SUFFIXES ${_jpegturbo_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
        else()
            set(_jpegturbo_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
            # find .lib
            set(CMAKE_FIND_LIBRARY_SUFFIXES .lib)
            foreach(search ${_JPEGTURBO_SEARCHES})
                find_library(JPEGTURBO_IMPLIB_RELEASE NAMES turbojpeg NAMES_PER_DIR ${${search}} PATH_SUFFIXES lib)
                find_library(JPEGTURBO_IMPLIB_DEBUG NAMES turbojpegd turbojpeg NAMES_PER_DIR ${${search}} PATH_SUFFIXES lib)
            endforeach()
            # find .dll
            set(CMAKE_FIND_LIBRARY_SUFFIXES .dll)
            foreach(search ${_JPEGTURBO_SEARCHES})
                find_library(JPEGTURBO_LIBRARY_RELEASE NAMES turbojpeg NAMES_PER_DIR ${${search}} PATH_SUFFIXES bin)
                find_library(JPEGTURBO_LIBRARY_DEBUG NAMES turbojpegd turbojpeg NAMES_PER_DIR ${${search}} PATH_SUFFIXES bin)
            endforeach()
            set(CMAKE_FIND_LIBRARY_SUFFIXES ${_jpegturbo_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
        endif()
    elseif(CMAKE_SYSTEM_NAME MATCHES "Linux" OR CMAKE_SYSTEM_NAME MATCHES "Android")
        # on Ubuntu, apt install libjpeg-turbo8-dev use libjpeg.h and libjpeg.a/.so as names
        # but we should use apt install libturbojpeg0-dev
        if(JPEGTURBO_USE_STATIC_LIBS)
            set(_jpegturbo_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
            set(CMAKE_FIND_LIBRARY_SUFFIXES .a)
        endif()
        message(STATUS "--- CMAKE_FIND_LIBRARY_SUFFIXES is: ${CMAKE_FIND_LIBRARY_SUFFIXES}")
        find_library(JPEGTURBO_LIBRARY_RELEASE NAMES turbojpeg)
        find_library(JPEGTURBO_LIBRARY_DEBUG   NAMES turbojpeg)
        message(STATUS "--- JPEGTURBO_LIBRARY_RELEASE is: ${JPEGTURBO_LIBRARY_RELEASE}")
        message(STATUS "--- JPEGTURBO_LIBRARY_DEBUG   is: ${JPEGTURBO_LIBRARY_DEBUG}")
        if(JPEGTURBO_USE_STATIC_LIBS)
            set(CMAKE_FIND_LIBRARY_SUFFIXES ${_jpegturbo_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
        endif()
    elseif(APPLE)
        set(_jpegturbo_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
        if(JPEGTURBO_USE_STATIC_LIBS)
            set(CMAKE_FIND_LIBRARY_SUFFIXES .a)
        else()
            set(CMAKE_FIND_LIBRARY_SUFFIXES .tbd .dylib .so)
        endif()
        foreach(search ${_JPEGTURBO_SEARCHES})
            find_library(JPEGTURBO_LIBRARY_RELEASE NAMES turbojpeg ${${search}} PATH_SUFFIXES lib)
            find_library(JPEGTURBO_LIBRARY_DEBUG   NAMES turbojpeg ${${search}} PATH_SUFFIXES lib)
        endforeach()
        set(CMAKE_FIND_LIBRARY_SUFFIXES ${_jpegturbo_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
    endif()

    include(SelectLibraryConfigurations)
    select_library_configurations(JPEGTURBO)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(JPEGTURBO REQUIRED_VARS JPEGTURBO_LIBRARY JPEGTURBO_INCLUDE_DIR)

if(JPEGTURBO_FOUND)
    set(JPEGTURBO_INCLUDE_DIRS ${JPEGTURBO_INCLUDE_DIR})
    
    if(NOT JPEGTURBO_LIBRARIES)
        set(JPEGTURBO_LIBRARIES ${JPEGTURBO_LIBRARY})
    endif()

    if(NOT TARGET JPEGTURBO::JPEGTURBO)
        if(MSVC)
            if(JPEGTURBO_USE_STATIC_LIBS)
                add_library(JPEGTURBO::JPEGTURBO STATIC IMPORTED)
                set_target_properties(JPEGTURBO::JPEGTURBO PROPERTIES
                    INTERFACE_INCLUDE_DIRECTORIES "${JPEGTURBO_INCLUDE_DIRS}"
                    IMPORTED_LOCATION_DEBUG "${JPEGTURBO_LIBRARY_DEBUG}"
                    IMPORTED_LOCATION_RELEASE "${JPEGTURBO_LIBRARY_RELEASE}"

                    MAP_IMPORTED_CONFIG_MINSIZEREL Release
                    MAP_IMPORTED_CONFIG_RELWITHDEBINFO Release
                )
            else()
                add_library(JPEGTURBO::JPEGTURBO SHARED IMPORTED)
                set_target_properties(JPEGTURBO::JPEGTURBO PROPERTIES
                    INTERFACE_INCLUDE_DIRECTORIES "${JPEGTURBO_INCLUDE_DIRS}"
                    IMPORTED_IMPLIB_DEBUG "${JPEGTURBO_IMPLIB_DEBUG}"
                    IMPORTED_IMPLIB_RELEASE "${JPEGTURBO_IMPLIB_RELEASE}"

                    IMPORTED_LOCATION_DEBUG "${JPEGTURBO_LIBRARY_DEBUG}"
                    IMPORTED_LOCATION_RELEASE "${JPEGTURBO_LIBRARY_RELEASE}"
                    
                    MAP_IMPORTED_CONFIG_MINSIZEREL Release
                    MAP_IMPORTED_CONFIG_RELWITHDEBINFO Release
                )
                get_target_property(JPEGTURBO_DEBUG_DLL JPEGTURBO::JPEGTURBO IMPORTED_LOCATION_DEBUG)
                get_target_property(JPEGTURBO_RELEASE_DLL JPEGTURBO::JPEGTURBO IMPORTED_LOCATION_RELEASE)
                set(JPEGTURBO_DLL
                    $<$<CONFIG:Debug>:"${JPEGTURBO_DEBUG_DLL}">
                    $<$<CONFIG:Release>:"${JPEGTURBO_RELEASE_DLL}">
                    $<$<CONFIG:MinSizeRel>:"${JPEGTURBO_RELEASE_DLL}">
                    $<$<CONFIG:RelWithDebInfo>:"${JPEGTURBO_RELEASE_DLL}">
                )
            endif()
        else()
            add_library(JPEGTURBO::JPEGTURBO UNKNOWN IMPORTED)
            set_target_properties(JPEGTURBO::JPEGTURBO PROPERTIES
                INTERFACE_INCLUDE_DIRECTORIES "${JPEGTURBO_INCLUDE_DIRS}")
            
            if(JPEGTURBO_LIBRARY_RELEASE)
                set_property(TARGET JPEGTURBO::JPEGTURBO APPEND PROPERTY
                    IMPORTED_CONFIGURATIONS RELEASE)
                set_target_properties(JPEGTURBO::JPEGTURBO PROPERTIES
                    IMPORTED_LOCATION_RELEASE "${JPEGTURBO_LIBRARY_RELEASE}")
            endif()

            if(JPEGTURBO_LIBRARY_DEBUG)
                set_property(TARGET JPEGTURBO::JPEGTURBO APPEND PROPERTY
                    IMPORTED_CONFIGURATIONS DEBUG)
                set_target_properties(JPEGTURBO::JPEGTURBO PROPERTIES
                    IMPORTED_LOCATION_DEBUG "${JPEGTURBO_LIBRARY_DEBUG}")
            endif()

            if(NOT JPEGTURBO_LIBRARY_RELEASE AND NOT JPEGTURBO_LIBRARY_DEBUG)
                set_property(TARGET JPEGTURBO::JPEGTURBO APPEND PROPERTY
                    IMPORTED_LOCATION "${JPEGTURBO_LIBRARY}")
            endif()
        endif()
    endif()
endif()
