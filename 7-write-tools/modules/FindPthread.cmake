# Find Pthread package
# It is either an .h+.a/.so library, or an header-only library
# Usage:
# find_package(Pthread)
# target_link_libraries(your_target Pthread::Pthread)
#----------------------------------------------------------------------
# Pthread is a header-only library on Android NDK, MacOSX.
# Pthread can also be an header-only library.
#
# ubuntu 16.04:
#   gcc 5.4.0 requires explicit linking to pthread
#   GLIBC version 2.23
# ubuntu 20.04:
#   gcc 9.4.0 requires explicit linking to pthread
#   /usr/lib/x86_64-linux-gnu/libpthread.a is 6.3M
#   /usr/lib/x86_64-linux-gnu/libpthread-2.31.so is 156K
#  GLIBC version: 2.31
# ubuntu 22.04
#   gcc 11.4.0 on ubuntu 22.04 does not require explicit linking to pthread
#   /usr/lib/x86_64-linux-gnu/libpthread.a is 4KB
#   /usr/lib/x86_64-linux-gnu/libpthread.so.0 is 24KB
#   GLIBC version: 2.35
# https://godbolt.org/z/a8KncEjeG  godbolt GCC 13.2 looks like version higher than 11.4.0(the ubuntu22.04 default one)
#   but GLIBC version 2.31, still requires explicit linking to pthread
# https://developers.redhat.com/articles/2021/12/17/why-glibc-234-removed-libpthread#
#   https://gitlab.kitware.com/cmake/cmake/-/issues/23092
#   GLIBC version 2.34, libpthread is removed, and pthread is integrated into libc

include(check_glibc_version.cmake)
include(CheckFunctionExists)

# find header file
find_path(Pthread_INCLUDE_DIR NAMES pthread.h)

# find library file
CHECK_GLIBC_VERSION(GLIBC_FOUND GLIBC_VERSION)

# skip on Android due to implemened in Bionic
if(ANDROID OR (CMAKE_SYSTEM_NAME MATCHES "Darwin"))
  # nop
elseif(FOUND_GLIBC AND GLIBC_VERSION VERSION_LESS 2.35)
  # for glibc version < 2.34, find pthread library
  find_library(Pthread_LIBRARY NAMES pthread)
endif()

if(Pthread_INCLUDE_DIR)
  if(Pthread_LIBRARY)
    set(Pthread_FOUND TRUE)
  else()
    check_function_exists(pthread_create Pthread_FOUND)
    set(Pthread_LIBRARY "")
  endif()
else()
  set(Pthread_FOUND FALSE)
  set(Pthread_LIBRARY "")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Pthread
    FOUND_VAR
        Pthread_FOUND
    REQUIRED_VARS
        Pthread_INCLUDE_DIR
)

mark_as_advanced(Pthread_INCLUDE_DIR Pthread_LIBRARY)

# encapsulate as a target (package)
if(Pthread_FOUND AND NOT TARGET Pthread::Pthread)
  if(Pthread_LIBRARY)
    get_filename_component(file_ext ${Pthread_LIBRARY} EXT)
    if(file_ext MATCHES "\\.a")
      set(lib_type "STATIC")
    else()
      set(lib_type "SHARED")
    endif()
    add_library(Pthread::Pthread "${lib_type}" IMPORTED)
    set_target_properties(Pthread::Pthread PROPERTIES
      IMPORTED_LOCATION "${Pthread_LIBRARY}"
    )
  else()
    add_library(Pthread::Pthread INTERFACE IMPORTED)
  endif()
  set_target_properties(Pthread::Pthread PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${Pthread_INCLUDE_DIR}"
  )
endif()