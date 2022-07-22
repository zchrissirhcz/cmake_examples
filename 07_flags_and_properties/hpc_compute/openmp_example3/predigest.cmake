#----------------------------------------------------------------------
# predigest.cmake
# 
# predigest 意为简化， predigest.cmake 提供一系列API来简化依赖库的处理
#----------------------------------------------------------------------


#----------------------------------------------------------------------
### @brief 获取当前构建的目标平台的静态库文件后缀
###
### @usage 
### @code{.cmake}
### set(ext_name "")
### get_static_library_extension(ext_name)
### message(STATUS "ext_name: ${ext_name}")
### @endcode
#----------------------------------------------------------------------
function(get_static_library_extension extension)
    if(ANDROID OR (CMAKE_SYSTEM_NAME MATCHES "Linux") OR (CMAKE_SYSTEM_NAME MATCHES "Darwin"))
        set(${extension} ".a" PARENT_SCOPE)
    elseif(CMAKE_SYSTEM_NAME MATCHES "Windows")
        set(${extension} ".lib" PARENT_SCOPE)
    endif()
endfunction()

#----------------------------------------------------------------------
### @brief 获取当前构建的目标平台的动态库文件后缀
###
### @usage 
### @code{.cmake}
### set(ext_name "")
### get_shared_library_extension(ext_name)
### message(STATUS "ext_name: ${ext_name}")
### @endcode
#----------------------------------------------------------------------
function(get_shared_library_extension extension)
    if(ANDROID OR (CMAKE_SYSTEM_NAME MATCHES "Linux"))
        set(${extension} ".so" PARENT_SCOPE)
    elseif(CMAKE_SYSTEM_NAME MATCHES "Darwin")
        set(${extension} ".dylib" PARENT_SCOPE)
    elseif(CMAKE_SYSTEM_NAME MATCHES "Windows")
        set(${extension} ".dll" PARENT_SCOPE)
    endif()
endfunction()

#----------------------------------------------------------------------
### @brief 查找包，并且只找静态库
### @details 对 find_package 的简单封装
#----------------------------------------------------------------------
macro(find_static_package)
    set(_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
    #set(CMAKE_FIND_LIBRARY_SUFFIXES .a / .lib)
    set(lib_extension "")
    get_static_library_extension(lib_extension)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${lib_extension})
    find_package(${ARGV})
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
endmacro()

#----------------------------------------------------------------------
### @brief 查找包，并且只找动态库
### @details 对 find_package 的简单封装
#----------------------------------------------------------------------
macro(find_shared_package)
    set(_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
    #set(CMAKE_FIND_LIBRARY_SUFFIXES .so / .dylib / .dll)
    set(lib_extension "")
    get_shared_library_extension(lib_extension)
    # TODO: ensure ARGC == 1
    # message(STATUS ">>> ARGV:${ARGV}")
    # message(STATUS ">>> ARGV0:${ARGV0}")
    find_package(${ARGV0})
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
endmacro()

#----------------------------------------------------------------------
### @brief 给目标链接 OpenMP 库
###
### @details 通常来说， 直接用这个 target_link_openmp() ， 方便有简洁
### 但如果要定制， 或者对于新的平台， 还是建议手动用 find_static_library(OpenMP) 
### 或 find_shared_library(OpenMP).调试OK后，再更新回本函数
###
### @usage
### @code{.cmake}
### target_link_openmp(my_target PUBLIC)
### @endcode
#----------------------------------------------------------------------
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

