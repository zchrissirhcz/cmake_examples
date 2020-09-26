set(_JPEGTURBO_SEARCHES)

# Search JPEGTURBO_ROOT first if it is set.
if(JPEGTURBO_ROOT)
    set(_JPEGTURBO_SEARCH_ROOT PATHS ${JPEGTURBO_ROOT} NO_DEFAULT_PATH)
    list(APPEND _JPEGTURBO_SEARCHES _JPEGTURBO_SEARCH_ROOT)
endif()

# TODO: add normal search directories here


# Try each search configurations.
find_path(JPEGTURBO_INCLUDE_DIR NAMES turbojpeg.h HINTS ${_JPEGTURBO_SEARCHES} PATH_SUFFIXES include)
message(STATUS "--- JPEGTURBO_INCLUDE_DIR is: ${JPEGTURBO_INCLUDE_DIR}")

# Allow JPEGTURBO_LIBRARY to be set manually, as the location of the jpeg-turbo library
if(NOT JPEGTURBO_LIBRARY)
    if(MSVC)
        message(FATAL_ERROR "--- not implemented yet !")
    elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
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
        message(FATAL_ERROR "--- not implemented yet !")
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
            message(FATAL_ERROR "--- not implemented yet !")
        elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
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
        elseif(APPLE)
            message(FATAL_ERROR "--- not implemented yet !")
        endif()
    endif()
endif()
