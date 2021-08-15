cmake_minimum_required(VERSION 3.17)

project(openmp_example2)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 11)

#----------------------------------------------------------------------
# openmp utility macros
#----------------------------------------------------------------------
function(get_static_library_extension extension)
    if(ANDROID OR (CMAKE_SYSTEM_NAME MATCHES "Linux") OR (CMAKE_SYSTEM_NAME MATCHES "Darwin"))
        set(${extension} ".a" PARENT_SCOPE)
    elseif(CMAKE_SYSTEM_NAME MATCHES "Windows")
        set(${extension} ".lib" PARENT_SCOPE)
    endif()
endfunction()

function(get_shared_library_extension extension)
    if(ANDROID OR (CMAKE_SYSTEM_NAME MATCHES "Linux"))
        set(${extension} ".so" PARENT_SCOPE)
    elseif(CMAKE_SYSTEM_NAME MATCHES "Darwin")
        set(${extension} ".dylib" PARENT_SCOPE)
    elseif(CMAKE_SYSTEM_NAME MATCHES "Windows")
        set(${extension} ".dll" PARENT_SCOPE)
    endif()
endfunction()

macro(find_static_package)
    set(_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
    #set(CMAKE_FIND_LIBRARY_SUFFIXES .a / .lib)
    set(lib_extension "")
    get_static_library_extension(lib_extension)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${lib_extension})
    find_package(${ARGV})
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
endmacro()

macro(find_shared_package)
    set(_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
    #set(CMAKE_FIND_LIBRARY_SUFFIXES .so / .dylib / .dll)
    set(lib_extension "")
    get_shared_library_extension(lib_extension)
    find_package(${ARGV})
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
endmacro()

macro(target_link_openmp)
    if(ANDROID_NDK_MAJOR AND (ANDROID_NDK_MAJOR GREATER 20))
        set(_USE_STATIC_OPENMP TRUE)
    else()
        set(_USE_STATIC_OPENMP FALSE)
    endif()
    
    if(_USE_STATIC_OPENMP)
        find_static_package(OpenMP REQUIRED)
    else()
        find_shared_package(OpenMP REQUIRED)
    endif()

    if(NOT TARGET OpenMP::OpenMP_CXX AND (OpenMP_CXX_FOUND OR OPENMP_FOUND))
        target_compile_options(${ARGV} ${OpenMP_CXX_FLAGS})
    endif()

    if(OpenMP_CXX_FOUND OR OPENMP_FOUND)
        if(OpenMP_CXX_FOUND)
            target_link_libraries(${ARGV} OpenMP::OpenMP_CXX)
        else()
            target_link_libraries(${ARGV} "${OpenMP_CXX_FLAGS}")
        endif()
    endif()

    #message(STATUS ">>> inside, OpenMP_CXX_LIBRARIES: ${OpenMP_CXX_LIBRARIES}")
    #message(STATUS ">>> inside, OpenMP_CXX_FLAGS: ${OpenMP_CXX_FLAGS}")

endmacro()

#----------------------------------------------------------------------
# user defined targets
#----------------------------------------------------------------------
add_library(hello STATIC
    hello.h
    hello.cpp
)

add_executable(testbed testbed.cpp)
target_link_libraries(testbed PUBLIC hello)

#----------------------------------------------------------------------
# user targets links to openmp
#----------------------------------------------------------------------
target_link_openmp(hello PRIVATE)
target_link_openmp(testbed PUBLIC)

message(STATUS ">>> outside, OpenMP_CXX_LIBRARIES: ${OpenMP_CXX_LIBRARIES}")
message(STATUS ">>> outside, OpenMP_CXX_FLAGS: ${OpenMP_CXX_FLAGS}")


# get_cmake_property(_variableNames VARIABLES)
# list (SORT _variableNames)
# foreach (_variableName ${_variableNames})
#     message(STATUS "${_variableName}=${${_variableName}}")
# endforeach()
