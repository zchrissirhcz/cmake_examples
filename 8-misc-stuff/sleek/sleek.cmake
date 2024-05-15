#-------------------------------------------------------------
# sleek.cmake
# Brings you better cmake usage experience
# 通过封装一系列常见功能，sleek.cmake 将提升 CMake 的使用体验
#-------------------------------------------------------------

set(sleek_version "0.0.1")

#----------------------------------------------------------------------
# 默认开启的好用的全局设置
#----------------------------------------------------------------------
# 让 Ninja 输出彩色的编译报错信息
if(CMAKE_GENERATOR MATCHES "Ninja")
  if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    add_compile_options(-fdiagnostics-color=always)
  elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    add_compile_options(-fcolor-diagnostics)
  endif()
endif()


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

# 在当前 CMAKE_BUILD_TYPE 的 FLAGS 中添加 debug symbol (-g)
macro(sleek_add_debug_symbol)
  # TODO: if on MSVC, the flags is not -g
  if(CMAKE_BUILD_TYPE MATCHES "Debug")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -g")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g")
  elseif(CMAKE_BUILD_TYPE MATCHES "Release")
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -g")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -g")
  elseif(CMAKE_BUILD_TYPE MATCHES "RelWithDebInfo")
    set(CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO} -g")
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -g")
  elseif(CMAKE_BUILD_TYPE MATCHES "MinSizeRel")
    set(CMAKE_C_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL} -g")
    set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} -g")
  elseif(CMAKE_BUILD_TYPE EQUAL "None" OR NOT CMAKE_BUILD_TYPE)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
  else()
    message(FATAL_ERROR "unsupported CMAKE_BUILD_TYPE for sleek_add_debug_symbol: ${CMAKE_BUILD_TYPE}")
  endif()
endmacro()


# 检查当前 CMAKE_BUILD_TYPE 中是否含有调试符号的 flag (-g)
# NOTE: currently only detect for CXX.
function(sleek_check_exist_debug_symbol)
  if(CMAKE_BUILD_TYPE MATCHES "Debug")
    string_find_element(${CMAKE_CXX_FLAGS_DEBUG} -g exist_debug_symbol)
  elseif(CMAKE_BUILD_TYPE MATCHES "Release")
    string_find_element(${CMAKE_CXX_FLAGS_RELEASE} -g exist_debug_symbol)
  elseif(CMAKE_BUILD_TYPE MATCHES "RelWithDebInfo")
    string_find_element(${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -g exist_debug_symbol)
  elseif(CMAKE_BUILD_TYPE MATCHES "MinSizeRel")
    string_find_element(${CMAKE_CXX_FLAGS_MINSIZEREL} -g exist_debug_symbol)
  elseif(CMAKE_BUILD_TYPE EQUAL "None" OR NOT CMAKE_BUILD_TYPE)
    string_find_element(${CMAKE_CXX_FLAGS} -g exist_debug_symbol)
  else()
    message(FATAL_ERROR "unsupported CMAKE_BUILD_TYPE for sleek_check_exist_debug_symbol: ${CMAKE_BUILD_TYPE}")
  endif()

  if(exist_debug_symbol)
    message(STATUS " exist debug symbo: YES")
  else()
    message(STATUS " exist debug symbo: NO")
  endif()
endfunction()

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

# 添加若干个 flags 到当前 CMAKE_BUILD_TYPE 的 flags 中。被添加的是编译选项（包括-fsanitize=address这样的，编译选项会同时开链接的选项）
# Usage:
# sleek_add_flag("-g -fno-omit-frame-pointer -fsanitize=address"), param `flags` should be quoted if > 1 flags provided.
macro(sleek_add_flags flags)
  if(CMAKE_BUILD_TYPE MATCHES "Debug")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} ${flags}")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} ${flags}")
  elseif(CMAKE_BUILD_TYPE MATCHES "Release")
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} ${flags}")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} ${flags}")
  elseif(CMAKE_BUILD_TYPE MATCHES "RelWithDebInfo")
    set(CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO} ${flags}")
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} ${flags}")
  elseif(CMAKE_BUILD_TYPE MATCHES "MinSizeRel")
    set(CMAKE_C_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL} ${flags}")
    set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} ${flags}")
  elseif(CMAKE_BUILD_TYPE EQUAL "None" OR NOT CMAKE_BUILD_TYPE)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${flags}")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${flags}")
  else()
    message(FATAL_ERROR "unsupported CMAKE_BUILD_TYPE for sleek_add_flags: ${CMAKE_BUILD_TYPE}")
  endif()
endmacro()

# 添加链接选项
macro(sleek_add_linker_flags flags)
  if(CMAKE_BUILD_TYPE MATCHES "Debug")
    set(CMAKE_LINKER_FLAGS_DEBUG "${CMAKE_LINKER_FLAGS_DEBUG} ${flags}")
  elseif(CMAKE_BUILD_TYPE MATCHES "Release")
    set(CMAKE_LINKER_FLAGS_RELEASE "${CMAKE_LINKER_FLAGS_RELEASE} ${flags}")
  elseif(CMAKE_BUILD_TYPE MATCHES "RelWithDebInfo")
    set(CMAKE_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_LINKER_FLAGS_RELWITHDEBINFO} ${flags}")
  elseif(CMAKE_BUILD_TYPE MATCHES "MinSizeRel")
    set(CMAKE_LINKER_FLAGS_MINSIZEREL "${CMAKE_LINKER_FLAGS_MINSIZEREL} ${flags}")
  elseif(CMAKE_BUILD_TYPE EQUAL "None" OR NOT CMAKE_BUILD_TYPE)
    set(CMAKE_LINKER_FLAGS "${CMAKE_LINKER_FLAGS} ${flags}")
  else()
    message(FATAL_ERROR "unsupported CMAKE_BUILD_TYPE for sleek_add_linker_flags: ${CMAKE_BUILD_TYPE}")
  endif()
endmacro()

# 开启 AddressSanitizer
macro(sleek_add_asan_flags)
  sleek_add_flags("-g -fno-omit-frame-pointer -fsanitize=address")
endmacro()

# 开启 ThreadSanitizer
macro(sleek_add_tsan_flags)
  sleek_add_flags("-g -fno-omit-frame-pointer -fsanitize=thread")
endmacro()



#----------------------------------------------------------------------
# Debugging
#----------------------------------------------------------------------
# debug.cmake 解决了什么问题？
# 1. 对于一个 target， 想知道它的所有（非空）属性的值
#    例如， target 的类型是什么， 如果是 find_package 引入的， 那么它是头文件和库文件的位置在哪儿？
#           更进一步，如果是C++标准是11或更高的，也希望打印出来；
#           再进一步，如果开启了no-exception，no-rtti的话，也希望打印出来
#           如果是用户自行创建的target，能否把所有源代码文件也列出来？
#           另外， 头文件搜索目录是哪些，也列一下； 比如经典的，在交叉编译环境下，能找到opencv库但是链接时候说库文件格式不对，其实是压根儿就没有编译安装交叉编译版本的opencv，然后找到了host版本的opencv
#
# 2. 列出所有的 target
#       比如默认期望的是都是用静态库，然而蛋疼的是，引入的库，比如zlib，libpng，居然是动态库。
#       也就是说， 在好不容易用find_package找了一些包之后， 链接还是出问题的情况下，
#       如果能够把所有引入的依赖项中的每个target都打印出来， 这样就比较好确定，它是不是符合预期的
#       例如典型的， opencv在android平台，由于android系统自带了zlib的动态库，所以可以直接链接动态库
#       而如果是从源码编译的zlib，希望使用的是静态库，而不是“好不容易编译了zlib静态库，结果链接的时候还是找到并使用了动态库”
#--------------------------------------------------------------------------------------------------------------------------------------------

# 判断一个 target 是否为 IMPORTED 类型
function(sleek_is_target_imported target output_var)
  get_target_property(is_imporated ${target} IMPORTED)
  set(${output_var} "${is_imporated}" PARENT_SCOPE)
endfunction()

#----------------------------------------------------------------------
# 1. 获取某个 target 的所有属性
#----------------------------------------------------------------------
# target specific properties + inheritated from global properties
# https://stackoverflow.com/questions/32183975/how-to-print-all-the-properties-of-a-target-in-cmake
function(sleek_print_target_all_properties tgt)
  if(NOT TARGET ${tgt})
    message(FATAL_ERROR "There is no target named '${tgt}'")
    return()
  endif()

  ## Get all properties that cmake supports
  execute_process(COMMAND cmake --help-property-list OUTPUT_VARIABLE CMAKE_PROPERTY_LIST)
  ## Convert command output into a CMake list
  string(REGEX REPLACE ";" "\\\\;" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
  string(REGEX REPLACE "\n" ";" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
  list(REMOVE_DUPLICATES CMAKE_PROPERTY_LIST)
  sleek_is_target_imported(${tgt} is_tgt_imported)
  if(NOT ${is_tgt_imported})
    #list(REMOVE_ITEM CMAKE_PROPERTY_LIST LOCATION)
    list(FILTER CMAKE_PROPERTY_LIST EXCLUDE REGEX "IMPORTED_*")
    list(FILTER CMAKE_PROPERTY_LIST EXCLUDE REGEX "LOCATION*")
    
    #message(STATUS "CMAKE_PROPERTY_LIST is:${CMAKE_PROPERTY_LIST}")
    #message(FATAL_ERROR "${tgt} is not imported")
  else()
    #message(STATUS "CMAKE_PROPERTY_LIST is:${CMAKE_PROPERTY_LIST}")
    #message(FATAL_ERROR "${tgt} is imported")
  endif()

  foreach(prop ${CMAKE_PROPERTY_LIST})
    string(REPLACE "<CONFIG>" "${CMAKE_BUILD_TYPE}" prop ${prop})
    get_target_property(propval ${tgt} ${prop})
    if(propval)
      message(STATUS "${tgt} ${prop} = ${propval}")
    endif()
  endforeach(prop)
endfunction()

#----------------------------------------------------------------------
# 2. 获取全局属性
#----------------------------------------------------------------------
# 注： 只列出了个人比较关心的几个属性。其他属性见 https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#id2
function(sleek_print_global_properties)
  message(STATUS "Global properties")
  set(global_prop_list
    INCLUDE_DIRECTORIES
    LINK_DIRECTORIES
    LINK_OPTIONS
    COMPILE_DEFINITIONS
    COMPILE_OPTIONS
    DEFINITIONS
  )

  foreach(prop ${global_prop_list})
    get_property(propval GLOBAL PROPERTY ${prop})
    if(propval)
      message(STATUS "    ${prop}: ${propval}")
    else()
      message(STATUS "    ${prop}: ")
    endif()
  endforeach()
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

