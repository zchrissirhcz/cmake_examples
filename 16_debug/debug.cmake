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

#----------------------------------------------------------------------
# 1. 获取某个 target 的所有属性
#----------------------------------------------------------------------
# target specific properties + inheritated from global properties
# https://stackoverflow.com/questions/32183975/how-to-print-all-the-properties-of-a-target-in-cmake
function(my_print_target_all_properties tgt)
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
function(my_print_global_properties)
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
function(my_print_target_properties tgt)
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

function(my_print_target_list_properties)
  foreach(tgt ${ARGV})
    my_print_target_properties(${tgt})
  endforeach()
endfunction()

#----------------------------------------------------------------------
# 4. 列出自行创建的 targets
#----------------------------------------------------------------------
# 列出 build system 中添加的（也就是通常来说，用户自行添加的）targets
function(my_print_created_targets)
  get_property(build_system_targets DIRECTORY PROPERTY BUILDSYSTEM_TARGETS)
  message(STATUS ">>> build_system_targets : ${build_system_targets}")
endfunction()

#----------------------------------------------------------------------
# 5. 列出 imported targets
#----------------------------------------------------------------------
# 例如 find_package, find_lib 引入的依赖项
function(my_print_imported_targets)
  get_property(imported_targets DIRECTORY PROPERTY IMPORTED_TARGETS)
  message(STATUS ">>> imported_targets : ${imported_targets}")
endfunction()