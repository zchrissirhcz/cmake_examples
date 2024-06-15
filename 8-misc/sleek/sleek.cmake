set(sleek_version "0.0.1")

#----------------------------------------------------------------------
# General
#----------------------------------------------------------------------
# 在字符串 INPUT 中查找 QUERY ， 结果存放在 OUTPUT_VAR 中
# OUTPUT_VAR 的值只有两种可能： TRUE 和 FALSE ， 表示是否找到
function(sleek_string_find_element INPUT QUERY OUTPUT_VAR)
  # set(a ${CMAKE_CXX_FLAGS}) # input
  # set(b "-g") # target
  set(a "${INPUT}")
  set(b "${QUERY}")
  set(found_b FALSE)
  string(REPLACE " " ";" c "${a}") # 实现了 items2 到 items1 类型的转换
  foreach(val ${c})
    #message(STATUS "${val}")
    if(${val} STREQUAL "${b}")
      set(found_b TRUE)
    endif()
  endforeach()

  # if(found_b)
  #     message(STATUS "found ${b}")
  # else()
  #     message(STATUS "not found ${b}")
  # endif()

  set(${OUTPUT_VAR} "${found_b}" PARENT_SCOPE)
endfunction()


#----------------------------------------------------------------------
# FLAGS
#----------------------------------------------------------------------
# 删除当前 CMAKE_BUILD_TYPE 的 FLAGS 中的 debug symbol (-g)
macro(sleek_drop_debug_symbol)
  if(CMAKE_BUILD_TYPE MATCHES "Debug")
    string(REPLACE "-g" "" CMAKE_C_FLAGS ${CMAKE_C_FLAGS})
    string(REPLACE "-g" "" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
  elseif(CMAKE_BUILD_TYPE MATCHES "Release")
    string(REPLACE "-g" "" CMAKE_C_FLAGS_RELEASE ${CMAKE_C_FLAGS_RELEASE})
    string(REPLACE "-g" "" CMAKE_CXX_FLAGS_RELEASE ${CMAKE_CXX_FLAGS_RELEASE})
  elseif(CMAKE_BUILD_TYPE MATCHES "RelWithDebInfo")
    string(REPLACE "-g" "" CMAKE_C_FLAGS_RELWITHDEBINFO ${CMAKE_C_FLAGS_RELWITHDEBINFO})
    string(REPLACE "-g" "" CMAKE_CXX_FLAGS_RELWITHDEBINFO ${CMAKE_CXX_FLAGS_RELWITHDEBINFO})
  elseif(CMAKE_BUILD_TYPE MATCHES "MinSizeRel")
    string(REPLACE "-g" "" CMAKE_C_FLAGS_MINSIZEREL ${CMAKE_C_FLAGS_MINSIZEREL})
    string(REPLACE "-g" "" CMAKE_CXX_FLAGS_MINSIZEREL ${CMAKE_CXX_FLAGS_MINSIZEREL})
  elseif(CMAKE_BUILD_TYPE EQUAL "None" OR NOT CMAKE_BUILD_TYPE)
    string(REPLACE "-g" "" CMAKE_C_FLAGS ${CMAKE_C_FLAGS})
    string(REPLACE "-g" "" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
  else()
    message(FATAL_ERROR "unsupported CMAKE_BUILD_TYPE for sleek_drop_debug_symbol: ${CMAKE_BUILD_TYPE}")
  endif()
endmacro()

# 打印 C++ flags
function(sleek_print_cxx_flags)
  message(STATUS ">>> CXX Flags:")
  message(STATUS ">>>   Current CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")

  message(STATUS ">>>   CMAKE_CXX_FLAGS: ${CMAKE_CXX_FLAGS}")
  message(STATUS ">>>   CMAKE_CXX_FLAGS_DEBUG: ${CMAKE_CXX_FLAGS_DEBUG}")
  message(STATUS ">>>   CMAKE_CXX_FLAGS_RELEASE: ${CMAKE_CXX_FLAGS_RELEASE}")
  message(STATUS ">>>   CMAKE_CXX_FLAGS_RELWITHDEBINFO: ${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
  message(STATUS ">>>   CMAKE_CXX_FLAGS_MINSIZEREL: ${CMAKE_CXX_FLAGS_MINSIZEREL}")
endfunction()

# 打印 C flags
function(sleek_print_c_flags)
  message(STATUS ">>> C Flags:")
  message(STATUS ">>>   Current CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")

  message(STATUS ">>>   CMAKE_C_FLAGS: ${CMAKE_C_FLAGS}")
  message(STATUS ">>>   CMAKE_C_FLAGS_DEBUG: ${CMAKE_C_FLAGS_DEBUG}")
  message(STATUS ">>>   CMAKE_C_FLAGS_RELEASE: ${CMAKE_C_FLAGS_RELEASE}")
  message(STATUS ">>>   CMAKE_C_FLAGS_RELWITHDEBINFO: ${CMAKE_C_FLAGS_RELWITHDEBINFO}")
  message(STATUS ">>>   CMAKE_C_FLAGS_MINSIZEREL: ${CMAKE_C_FLAGS_MINSIZEREL}")
endfunction()

# 打印链接选项
function(sleek_print_linker_flags)
  message(STATUS ">>> Linker Flags:")
  message(STATUS ">>>   Current CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")

  message(STATUS ">>>   CMAKE_LINKER_FLAGS: ${CMAKE_LINKER_FLAGS}")
  message(STATUS ">>>   CMAKE_LINKER_FLAGS_DEBUG: ${CMAKE_LINKER_FLAGS_DEBUG}")
  message(STATUS ">>>   CMAKE_LINKER_FLAGS_RELEASE: ${CMAKE_LINKER_FLAGS_RELEASE}")
  message(STATUS ">>>   CMAKE_LINKER_FLAGS_RELWITHDEBINFO: ${CMAKE_LINKER_FLAGS_RELWITHDEBINFO}")
  message(STATUS ">>>   CMAKE_LINKER_FLAGS_MINSIZEREL: ${CMAKE_LINKER_FLAGS_MINSIZEREL}")
endfunction()


#----------------------------------------------------------------------
# 3. 获取某个 target 的属性
#----------------------------------------------------------------------
# 预期结果是， 不包含从全局继承来的属性
function(sleek_print_target_properties tgt)
  message(STATUS "${tgt} properties")
  if(NOT TARGET ${tgt})
    message(FATAL_ERROR "There is target named '${tgt}'")
  endif()

  set(tgt_prop_list
    TYPE # STATIC_LIBRARY, EXECUTABLE, INTERFACE_LIBRARY
    IMPORTED # TRUE / FALSE
    INTERFACE_COMPILE_OPTIONS # -fno-rtti;-fno-exceptions
    INTERFACE_INCLUDE_DIRECTORIES
    INTERFACE_LINK_LIBRARIES

    COMPILE_DEFINITIONS
    COMPILE_FEATURES
    COMPILE_FLAGS
    COMPILE_OPTIONS
    <CONFIG>_OUTPUT_NAME
    <CONFIG>_POSTFIX
  )
  if(MSCV)
    list(APPEND tgt_prop_list
      COMPILE_PDB_NAME
      COMPILE_PDB_NAME_<CONFIG>
      COMPILE_PDB_OUTPUT_DIRECTORY
      COMPILE_PDB_OUTPUT_DIRECTORY_<CONFIG>
    )
  endif()
  
  foreach(prop ${tgt_prop_list})
    string(REPLACE "<CONFIG>" "${CMAKE_BUILD_TYPE}" prop ${prop})
    get_target_property(propval ${tgt} ${prop})
    if(propval)
      message(STATUS "    ${prop}: ${propval}")
    else()
      message(STATUS "    ${prop}: ")
    endif()
  endforeach()

  get_target_property(is_imported ${tgt} IMPORTED)
  if(${is_imported})
    # can't get `LOCATION` property for non-imported targets
    set(imported_tgt_prop_list
      LOCATION
      IMPORTED_CONFIGURATIONS
    )
    foreach(prop ${imported_tgt_prop_list})
      get_target_property(propval ${tgt} ${prop})
      if(propval)
        message(STATUS "    ${prop}: ${propval}")
      endif()
    endforeach()
  endif()
  
  message(STATUS "")
endfunction()

function(sleek_print_target_list_properties)
  foreach(tgt ${ARGV})
    sleek_print_target_properties(${tgt})
  endforeach()
endfunction()

#----------------------------------------------------------------------
# 4. 列出自行创建的 targets
#----------------------------------------------------------------------
# 列出 build system 中添加的（也就是通常来说，用户自行添加的）targets
function(sleek_print_created_targets)
  get_property(build_system_targets DIRECTORY PROPERTY BUILDSYSTEM_TARGETS)
  message(STATUS ">>> build_system_targets : ${build_system_targets}")
endfunction()

#----------------------------------------------------------------------
# 5. 列出 imported targets
#----------------------------------------------------------------------
# 例如 find_package, find_lib 引入的依赖项
function(sleek_print_imported_targets)
  get_property(imported_targets DIRECTORY PROPERTY IMPORTED_TARGETS)
  message(STATUS ">>> imported_targets : ${imported_targets}")
endfunction()


#----------------------------------------------------------------------
# Package management
#----------------------------------------------------------------------

#----------------------------------------------------------------------
### @brief 获取当前构建的目标平台的静态库文件后缀
###
### @usage 
### @code{.cmake}
### set(ext_name "")
### sleek_get_static_library_extension(ext_name)
### message(STATUS "ext_name: ${ext_name}")
### @endcode
#----------------------------------------------------------------------
function(sleek_get_static_library_extension extension)
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
### sleek_get_shared_library_extension(ext_name)
### message(STATUS "ext_name: ${ext_name}")
### @endcode
#----------------------------------------------------------------------
function(sleek_get_shared_library_extension extension)
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
macro(sleek_find_static_package)
  set(_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
  #set(CMAKE_FIND_LIBRARY_SUFFIXES .a / .lib)
  set(lib_extension "")
  sleek_get_static_library_extension(lib_extension)
  set(CMAKE_FIND_LIBRARY_SUFFIXES ${lib_extension})
  find_package(${ARGV})
  set(CMAKE_FIND_LIBRARY_SUFFIXES ${_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
endmacro()

#----------------------------------------------------------------------
### @brief 查找包，并且只找动态库
### @details 对 find_package 的简单封装
#----------------------------------------------------------------------
macro(sleek_find_shared_package)
  set(_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
  #set(CMAKE_FIND_LIBRARY_SUFFIXES .so / .dylib / .dll)
  set(lib_extension "")
  sleek_get_shared_library_extension(lib_extension)
  find_package(${ARGV})
  set(CMAKE_FIND_LIBRARY_SUFFIXES ${_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
endmacro()

#----------------------------------------------------------------------
### @brief 给目标链接 OpenMP 库
###
### @details 通常来说， 直接用这个 sleek_target_link_openmp() ， 方便且简洁
### 但如果要定制， 或者对于新的平台， 还是建议手动用 find_static_library(OpenMP) 
### 或 find_shared_library(OpenMP).调试OK后，再更新回本函数
###
### @usage
### @code{.cmake}
### sleek_target_link_openmp(my_target PUBLIC)
### @endcode
#----------------------------------------------------------------------
macro(sleek_target_link_openmp)
  if(ANDROID_NDK_MAJOR AND (ANDROID_NDK_MAJOR GREATER 20))
    set(_USE_STATIC_OPENMP TRUE)
  else()
    set(_USE_STATIC_OPENMP FALSE)
  endif()
    
  if(_USE_STATIC_OPENMP)
    sleek_find_static_package(OpenMP REQUIRED)
  else()
    sleek_find_shared_package(OpenMP REQUIRED)
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

