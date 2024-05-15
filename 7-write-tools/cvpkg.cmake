# Author: Zhuo Zhang <imzhuo@foxmail.com>
# Homepage: https://github.com/zchrissirhcz
# Last update: 2023-10-20 13:20:07

#======================================================================
# Header guard
#======================================================================
if(CVPKG_INCLUDE_GUARD)
  return()
endif()
set(CVPKG_INCLUDE_GUARD 1)

#======================================================================
# Global variables
#======================================================================
set(CVPKG_AUTHOR "Zhuo Zhang <imzhuo@foxmail.com>")
set(CVPKG_CREATE_TIME "2023.04.23 13:00:00")
set(CVPKG_VERSION "2023-09-05 11:21:26")
set(CVPKG_VERBOSE 1)

#======================================================================
# Logging
#======================================================================
function(cvpkg_debug)
  if(CVPKG_VERBOSE GREATER 2)
    message(STATUS "CVPKG/D: ${ARGN}")
  endif()
endfunction()

function(cvpkg_error)
  if(CVPKG_VERBOSE GREATER 1)
    message(FATAL_ERROR "CVPKG/E: ${ARGN}")
  endif()
endfunction()

function(cvpkg_info)
  if(CVPKG_VERBOSE GREATER 0)
    message(STATUS "CVPKG/D: ${ARGN}")
  endif()
endfunction()

#======================================================================
# Determine if a list is empty
#======================================================================
# Example:
# cvpkg_is_list_empty(testbed_requires testbed_requires_empty)
# message(STATUS "testbed_requires_empty: ${testbed_requires_empty}")
#----------------------------------------------------------------------
function(cvpkg_is_list_empty the_list ret)
  list(LENGTH ${the_list} the_list_length)
  if(${the_list_length} EQUAL 0)
    set(${ret} TRUE PARENT_SCOPE)
  else()
    set(${ret} FALSE PARENT_SCOPE)
  endif()
endfunction()

#======================================================================
# Determine a library's type wrt filename extension
# Returns: SHARED_LIBRARY, STATIC_LIBRARY, UNKNOWN
#======================================================================
function(cvpkg_get_library_type library_path library_type)
  # first, we get the filename extension
  get_filename_component(library_filename_ext ${library_path} EXT)
  # then, we determine the library type
  # regular expression to match: one of: .dll, .so, .dylib, .tbd
  if(library_filename_ext MATCHES "\\.dll|.so|.dylib|.tbd")
    set(${library_type} "SHARED_LIBRARY" PARENT_SCOPE)
  elseif(library_filename_ext MATCHES "\\.lib|.a")
    set(${library_type} "STATIC_LIBRARY" PARENT_SCOPE)
  else()
    set(${library_type} "UNKNOWN" PARENT_SCOPE)
  endif()
endfunction()

function(cvpkg_is_package_system_library PACKAGE OUTPUT_VAR)
  # only if PACKAGE matches one of the following patterns, it is a system library
  # pthread, dl, rt, stdc++, m, opengl32

  # detect pthread
  # macosx: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX12.3.sdk/usr/lib/libpthread.tbd
  # ubuntu: /usr/lib/x86_64-linux-gnu/libpthread.a
  # ubuntu: /usr/lib/x86_64-linux-gnu/libpthread.so.0
  if(${PACKAGE} MATCHES "(lib)?pthread")
    set(IS_SYSTEM_LIBRARY TRUE)
  elseif(${PACKAGE} STREQUAL "dl")
    set(IS_SYSTEM_LIBRARY TRUE)
  elseif(${PACKAGE} STREQUAL "rt")
    set(IS_SYSTEM_LIBRARY TRUE)
  elseif(${PACKAGE} STREQUAL "stdc++")
    set(IS_SYSTEM_LIBRARY TRUE)
  elseif(${PACKAGE} STREQUAL "m")
    set(IS_SYSTEM_LIBRARY TRUE)
  elseif(${PACKAGE} STREQUAL "opengl32")
    set(IS_SYSTEM_LIBRARY TRUE)
  else()
    set(IS_SYSTEM_LIBRARY FALSE)
  endif()
  set(${OUTPUT_VAR} ${IS_SYSTEM_LIBRARY} PARENT_SCOPE)
endfunction()

#======================================================================
# Determine package types
#======================================================================
# Usage:
# cvpkg_is_target_header_only_package(${target_name} is_header_only)
# if(${is_header_only})
#    message(STATUS "${target_name} is header_only")
# else()
#    message(STATUS "${target_name} is not header_only")
# endif()
function(cvpkg_is_target_header_only_package TARGET OUTPUT_VAR)
  # https://cmake.org/cmake/help/latest/prop_tgt/TYPE.html
  get_target_property(type ${TARGET} TYPE)

  if(${type} STREQUAL "INTERFACE_LIBRARY")
    set(HEADER_ONLY TRUE)
  else()
    set(HEADER_ONLY FALSE)
  endif()

  set(${OUTPUT_VAR} ${HEADER_ONLY} PARENT_SCOPE)
endfunction()

# Usage:
# cvpkg_is_target_aliased_target(${target_name} is_aliased_package)
# if(${is_aliased_package})
#   message(STATUS "${target_name} is aliased target")
# else()
#   message(STATUS "${target_name} is not aliased target")
# endif()
function(cvpkg_is_target_aliased_target TARGET OUTPUT_VAR)
  get_target_property(aliased_target ${TARGET} ALIASED_TARGET)
  if(aliased_target)
    set(IS_ALIASED_PACKAGE TRUE)
  else()
    set(IS_ALIASED_PACKAGE FALSE)
  endif()

  set(${OUTPUT_VAR} ${IS_ALIASED_PACKAGE} PARENT_SCOPE)
endfunction()

# Usage:
# cvpkg_is_target_imported_target(${target_name} is_imported_package)
# if(${is_imported_package})
#   message(STATUS "${target_name} is imported target")
# else()
#   message(STATUS "${target_name} is not imported target")
# endif()
function(cvpkg_is_target_imported_target TARGET OUTPUT_VAR)
  get_target_property(aliased_target ${TARGET} IMPORTED)
  if(aliased_target)
    set(IS_ALIASED_PACKAGE TRUE)
  else()
    set(IS_ALIASED_PACKAGE FALSE)
  endif()

  set(${OUTPUT_VAR} ${IS_ALIASED_PACKAGE} PARENT_SCOPE)
endfunction()

#======================================================================
# 4. Recursively get required packages for a package. No duplicated.
#======================================================================
# Example: 
# cvpkg_get_flatten_requires(testbed flatten_pkgs)
# message(STATUS "flatten_pkgs: ${flatten_pkgs}")
#----------------------------------------------------------------------
function(cvpkg_get_flatten_requires input_pkg OUTPUT_VAR)
  list(LENGTH input_pkg input_pkg_length)
  if(NOT (${input_pkg_length} EQUAL 1))
    cvpkg_error("input_pkg should be single element list")
  endif()

  set(visited_pkgs "")
  set(pkg_stack ${input_pkg})
  while(TRUE)
    cvpkg_is_list_empty(pkg_stack pkg_stack_empty)
    if(${pkg_stack_empty})
      break()
    endif()

    cvpkg_debug("pkg_stack: ${pkg_stack}")
    # pop the last element
    list(POP_BACK pkg_stack pkg)
    cvpkg_debug("pkg: ${pkg}")

    # mark the element as visited
    if(NOT ("${pkg}" IN_LIST visited_pkgs))
      cvpkg_debug(" visiting ${pkg}")
      list(APPEND visited_pkgs ${pkg})

      # traverse it's required dependencies and put into pkg_stack
      get_target_property(subpkgs ${pkg} LINK_LIBRARIES)
      # cvpkg_debug("LINK_LIBRARIES: ${subpkgs}")
      if(subpkgs)
        foreach(subpkg ${subpkgs})
          if(TARGET ${subpkg}) # if called target_link_libraries() more than once, subpkgs contains stuffs like `::@(000001FAFA8C75C0)`
            cvpkg_debug("  subpkg: ${subpkg}")
            list(APPEND pkg_stack ${subpkg})
          endif()
        endforeach()
      endif()

      get_target_property(subpkgs ${pkg} INTERFACE_LINK_LIBRARIES)
      # cvpkg_debug("INTERFACE_LINK_LIBRARIES: ${subpkgs}")
      if(subpkgs)
        foreach(subpkg ${subpkgs})
          if(TARGET ${subpkg}) # if called target_link_libraries() more than once, subpkgs contains stuffs like `::@(000001FAFA8C75C0)`
            cvpkg_debug("  subpkg: ${subpkg}")
            list(APPEND pkg_stack ${subpkg})
          endif()
        endforeach()
      endif()
    endif()

  endwhile()

  list(POP_FRONT visited_pkgs visited_pkgs)
  set(${OUTPUT_VAR} ${visited_pkgs} PARENT_SCOPE)
endfunction()

#======================================================================
# get dependencies of a target/package
#======================================================================
# # add a argument to skip header-only packages
# function(cvpkg_get_package_requires TARGET OUTPUT_VAR
#                                     SKIP_HEADER_ONLY)
#   # get LINK_LIBRARIES
#   get_target_property(link_pkgs ${TARGET} LINK_LIBRARIES)

#   # get INTERFACE_LINK_LIBRARIES
#   get_target_property(interface_link_pkgs ${TARGET} INTERFACE_LINK_LIBRARIES)

#   # save to output
#   set(${OUTPUT_VAR} "${link_pkgs};${interface_link_pkgs}" PARENT_SCOPE)
# endfunction()

function(cvpkg_get_package_requires TARGET OUTPUT_VAR)
  # get LINK_LIBRARIES
  get_target_property(link_pkgs ${TARGET} LINK_LIBRARIES)
  cvpkg_debug("LINK_LIBRARIES: ${link_pkgs}")

  # get interface_link_pkgs
  get_target_property(interface_link_pkgs ${TARGET} INTERFACE_LINK_LIBRARIES)
  cvpkg_debug("INTERFACE_LINK_LIBRARIES: ${interface_link_pkgs}")

  # merge link_pkgs and interface_link_pkgs into one list
  set(all_pkgs "")
  if (link_pkgs)
    set(all_pkgs "${link_pkgs}")
  endif()
  if (interface_link_pkgs)
    set(all_pkgs "${all_pkgs};${interface_link_pkgs}")
  endif()

  # remove empty elements in all_pkgs
  list(REMOVE_ITEM all_pkgs "")
  
  set(dependencies "")

  set(ignore_header_only TRUE) # hack
  # 如果忽略header-only库，则过滤掉只有INTERFACE属性的依赖项
  if(ignore_header_only)
    foreach(pkg ${all_pkgs})
      if(TARGET ${pkg}) # if called target_link_libraries() more than once, subpkgs contains stuffs like `::@(000001FAFA8C75C0)`

        # determine if pkg is header-only
        cvpkg_is_target_header_only_package(${pkg} is_header_only)
        if(is_header_only)
          cvpkg_debug("  skip header-only: ${pkg}")
        else()
          cvpkg_debug("  using pkg: ${pkg}")
          list(APPEND dependencies ${pkg})
        endif()
      else()
        cvpkg_is_package_system_library(${pkg} is_system_library)
        if(${is_system_library})
          cvpkg_debug("  using system package: ${pkg}")
          list(APPEND dependencies ${pkg})
        endif()
      endif()

    endforeach()
  else()
    set(dependencies ${all_pkgs})
  endif()

  # convert to unique list
  list(REMOVE_DUPLICATES dependencies)

  # 返回依赖项列表
  set(${OUTPUT_VAR} "${dependencies}" PARENT_SCOPE)
endfunction()

#======================================================================
# Get link options from a target
#======================================================================
function(cvpkg_get_target_link_options TARGET OUTPUT_VAR)
  set(all_link_options "")

  get_target_property(link_options ${TARGET} LINK_OPTIONS)
  # cvpkg_debug("link_options: ${link_options}")
  if(link_options)
    set(all_link_options "${link_options}")
  endif()

  get_target_property(interface_link_options ${TARGET} INTERFACE_LINK_OPTIONS)
  # cvpkg_debug("interface_link_options: ${interface_link_options}")
  if(interface_link_options)
    set(all_link_options "${all_link_options};${interface_link_options}")
  endif()

  # remove empty elements
  list(REMOVE_ITEM all_link_options "")

  # convert list to space separated strings
  string(REPLACE ";" " " all_link_options "${all_link_options}")

  set(${OUTPUT_VAR} "${all_link_options}" PARENT_SCOPE)
endfunction()


#======================================================================
# Get required libraries recursively, and sort int topological order
#======================================================================
function(cvpkg_get_topological_requires TARGET OUTPUT_VAR)
  set(root_pkg ${TARGET})

  set(visited_pkgs "")
  set(pkg_deque ${root_pkg})
  while(TRUE)
    cvpkg_is_list_empty(pkg_deque pkg_deque_empty)
    if(${pkg_deque_empty})
      break()
    endif()

    # get first element in deque
    list(GET pkg_deque 0 pkg)
    
    # remove first element in deque
    list(REMOVE_AT pkg_deque 0)

    # if pkg is system package, put it to visited_pkgs
    cvpkg_is_package_system_library(${pkg} is_system_library)
    if(${is_system_library})
      list(APPEND visited_pkgs ${pkg})
      continue()
    endif()

    # if pkg is header-only type, skip it
    cvpkg_is_target_header_only_package(${pkg} is_header_only)
    if(${is_header_only})
      #cvpkg_debug("  - ${pkg} is header-only package, skip it")
      continue()
    else()
      #cvpkg_debug("  - ${pkg} is not header-only package")
    endif()

    # cvpkg_debug("processing pkg: ${pkg}")

    # get required packages of the first element
    cvpkg_get_package_requires(${pkg} subpkgs)

    # if the first element has no required packages, add it to visited_pkgs
    if(NOT subpkgs)
      list(APPEND visited_pkgs ${pkg})
      continue()
    endif()

    # traverse each required package
    set(all_subpkgs_visited TRUE)
    foreach(subpkg ${subpkgs})
      # print subpkg name
      # cvpkg_debug("  - subpkg: ${subpkg}")

      # if the required package is not in visited_pkgs, add it to back of pkg_deque
      if(NOT ("${subpkg}" IN_LIST visited_pkgs))
        list(APPEND pkg_deque "${subpkg}")
        # print pkg_deque
        # cvpkg_debug("  -- pkg_deque: ${pkg_deque}")
        set(all_subpkgs_visited FALSE)
      endif()
    endforeach()

    # if all required packages of the first element are visited, add it to visited_pkgs
    if(${all_subpkgs_visited})
      list(APPEND visited_pkgs "${pkg}")
    else()
      # if not, add it to back of pkg_deque
      list(APPEND pkg_deque "${pkg}")
    endif()
  endwhile()

  # remove root package from visited_pkgs
  list(REMOVE_ITEM visited_pkgs ${root_pkg})

  # remove duplicated elements in visited_pkgs
  list(REMOVE_DUPLICATES visited_pkgs)

  # reverse visited_pkgs
  list(REVERSE visited_pkgs)

  # cvpkg_debug("--------------------")
  # foreach(pkg ${visited_pkgs})
  #   cvpkg_debug("  - ${pkg}")
  # endforeach()

  set(${OUTPUT_VAR} "${visited_pkgs}" PARENT_SCOPE)
endfunction()

#======================================================================
function(cvpkg_adjust_system_library_order TOPOSORTED_PKGS OUTPUT_VAR)
  set(reordered_pkgs "")
  set(system_library_pkgs "")
  foreach(pkg ${TOPOSORTED_PKGS})
    cvpkg_is_package_system_library(${pkg} is_system_library)
    if(${is_system_library})
      list(APPEND system_library_pkgs ${pkg})
    else()
      list(APPEND reordered_pkgs ${pkg})
    endif()
  endforeach()
  # copy all system library packages into reordered_pkgs
  foreach(pkg ${system_library_pkgs})
    list(APPEND reordered_pkgs ${pkg})
  endforeach()
  set(${OUTPUT_VAR} "${reordered_pkgs}" PARENT_SCOPE)
endfunction()

function(cvpkg_scan_library_version_and_build_time TARGET OUTPUT_VERSION OUTPUT_BUILD_TIME)
    # get library path
    get_target_property(library_path ${TARGET} IMPORTED_LOCATION)
    if(NOT library_path)
      get_target_property(library_path ${TARGET} IMPORTED_LOCATION_RELEASE)
    endif()
    if(NOT library_path)
      get_target_property(library_path ${TARGET} IMPORTED_LOCATION_DEBUG)
    endif()
    if(NOT library_path)
      get_target_property(library_path ${TARGET} IMPORTED_LOCATION_MINSIZEREL)
    endif()
    if(NOT library_path)
      get_target_property(library_path ${TARGET} IMPORTED_LOCATION_RELWITHDEBINFO)
    endif()

    message("[DEBUG] library_path: ${library_path}")

    # get library version and build time
    if(library_path)
      get_filename_component(filehead "${library_path}" NAME_WE)
      file(STRINGS "${library_path}" file_text_content)
      #set(temp_out_txt "${filehead}.txt")
      #file(WRITE "${temp_out_txt}" ${file_text_content})

      cvpkg_scan_library_version_and_build_time_from_string("${file_text_content}" output_version output_build_time)
      set(${OUTPUT_VERSION} "${output_version}" PARENT_SCOPE)
      set(${OUTPUT_BUILD_TIME} "${output_build_time}" PARENT_SCOPE)
    else()
      set(${OUTPUT_VERSION} "" PARENT_SCOPE)
      set(${OUTPUT_BUILD_TIME} "" PARENT_SCOPE)
    endif()
endfunction()

set(cvpkg_already_copied_shared_library_lst "" CACHE INTERNAL "")

#======================================================================
# Copy imported lib for all build types
# Should only be used for shared libs, e.g. .dll, .so, .dylib
#======================================================================
# Example: 
# cvpkg_copy_imported_lib(testbed ${CMAKE_BINARY_DIR}/${testbed_output_dir})
#----------------------------------------------------------------------
function(cvpkg_copy_imported_lib targetName dstDir)
  set(prop_lst "IMPORTED_LOCATION;IMPORTED_LOCATION_DEBUG;IMPORTED_LOCATION_RELEASE;IMPORTED_LOCATION_MINSIZEREL;IMPORTED_LOCATION_RELWITHDEBINFO")
   
  if(NOT TARGET ${targetName})
    #message(STATUS "  return by case1")
    return()
  endif()

  # if(ALIASED_TARGET ${targetName})
  #   message(STATUS "  ${targetName} is aliased target")
  # endif()

  if(CMAKE_SYSTEM_NAME MATCHES "Windows")
    set(shared_library_filename_ext ".dll")
  elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
    set(shared_library_filename_ext ".so")
  elseif(CMAKE_SYSTEM_NAME MATCHES "Darwin")
    set(shared_library_filename_ext ".dylib")
  endif()

  get_target_property(pkg_type ${targetName} TYPE)
  if(NOT (${pkg_type} STREQUAL "SHARED_LIBRARY"))
    if(${pkg_type} STREQUAL "STATIC_LIBRARY")

      if(CMAKE_SYSTEM_NAME MATCHES "Windows")
        set(static_library_filename_ext ".lib")
      elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
        set(static_library_filename_ext ".a")
      elseif(CMAKE_SYSTEM_NAME MATCHES "Darwin")
        set(static_library_filename_ext ".a")
      endif()

      ### for static library targets, there might be `bin` directory, parallel to `lib` directory.
      # 先获取静态库文件路径
      foreach(prop ${prop_lst})
        get_target_property(static_library_path ${pkg} ${prop})
        if(static_library_path)
          # 获取静态库所在目录
          get_filename_component(static_library_live_directory ${static_library_path} DIRECTORY)
          # 获取静态库目录的上层目录
          get_filename_component(static_library_parent_directory ${static_library_live_directory} DIRECTORY)
          set(candidate_bin_dir "${static_library_parent_directory}/bin")
          # 判断上层目录是否存在 bin 目录, 如果存在 bin 目录， 执行扫描和拷贝
          if(EXISTS "${candidate_bin_dir}")
            set(glob_pattern "${candidate_bin_dir}/*${shared_library_filename_ext}")
            file(GLOB shared_library_path_lst "${glob_pattern}")
            foreach(shared_library_path ${shared_library_path_lst})
              if("${shared_library_path}" IN_LIST cvpkg_already_copied_shared_library_lst)
                continue()
              endif()

              get_filename_component(fileName ${shared_library_path} NAME)
              set(dstPath "${dstDir}/${fileName}")
              if(NOT EXISTS "${dstPath}")
                cvpkg_info("Copy ${shared_library_filename_ext} file (for static library, we detect and copy them!)")
                cvpkg_info("  - static_library_path: ${prop}=${static_library_path}")
                cvpkg_info("  - shared_library_path: ${shared_library_path}")
                #cvpkg_info("  - cvpkg_already_copied_shared_library_lst: ${cvpkg_already_copied_shared_library_lst}")
                cvpkg_info("  - dstDir: ${dstDir}")

                list(APPEND cvpkg_already_copied_shared_library_lst "${shared_library_path}")
                set(cvpkg_already_copied_shared_library_lst  "${cvpkg_already_copied_shared_library_lst}" CACHE INTERNAL "")
                execute_process(COMMAND ${CMAKE_COMMAND} -E copy ${shared_library_path} ${dstDir})
              endif()
            endforeach()
          endif()
        endif()
      endforeach()
    endif()
    
    return()
  endif()


  ### copy as the package description file (xxx-config.cmake or xxx.cmake) decribed
  set(pkg ${targetName})
  foreach(prop ${prop_lst})
    cvpkg_debug("!! prop: ${prop}")
    get_target_property(shared_library_path_lst ${pkg} ${prop})

    foreach(shared_library_path ${shared_library_path_lst})
      if(shared_library_path)
        if("${shared_library_path}" IN_LIST cvpkg_already_copied_shared_library_lst)
          continue()
        endif()
        list(APPEND cvpkg_already_copied_shared_library_lst "${shared_library_path}")
        set(cvpkg_already_copied_shared_library_lst  "${cvpkg_already_copied_shared_library_lst}" CACHE INTERNAL "")

        get_filename_component(fileName ${shared_library_path} NAME)
        set(dstPath "${dstDir}/${fileName}")
        if(NOT EXISTS "${dstPath}")
          cvpkg_info("Copy ${shared_library_filename_ext} file")
          cvpkg_info("  - package(target): ${pkg}")
          cvpkg_info("  - prop: ${prop}=${shared_library_path}")
          cvpkg_info("  - dstDir: ${dstDir}")
          execute_process(COMMAND ${CMAKE_COMMAND} -E copy ${shared_library_path} ${dstDir})
        endif()
      endif()
    endforeach()
  endforeach()

  ### copy un-tracked shared library files that under same directory of each tracked shared library files
  cvpkg_is_list_empty(cvpkg_already_copied_shared_library_lst copied_shared_library_path_lst_empty)
  if(${copied_shared_library_path_lst_empty})
    return()
  endif()

  # get directories of each copied shared library files
  set(shared_library_live_directory_lst "")
  foreach(copied_shared_library_path ${cvpkg_already_copied_shared_library_lst})
    get_filename_component(shared_library_live_directory ${copied_shared_library_path} DIRECTORY)
    list(APPEND shared_library_live_directory_lst "${shared_library_live_directory}")
  endforeach()

  # remove duplicated directories
  list(REMOVE_DUPLICATES "${shared_library_live_directory_lst}")

  # for each candidate directory, scan shared library files
  foreach(shared_library_live_directory ${shared_library_live_directory_lst})
    set(glob_pattern "${shared_library_live_directory}/*${shared_library_filename_ext}")
    file(GLOB shared_library_path_lst "${glob_pattern}")
    foreach(shared_library_path ${shared_library_path_lst})
      if("${shared_library_path}" IN_LIST cvpkg_already_copied_shared_library_lst)
        continue()
      endif()
      list(APPEND cvpkg_already_copied_shared_library_lst "${shared_library_path}")
      set(cvpkg_already_copied_shared_library_lst  "${cvpkg_already_copied_shared_library_lst}" CACHE INTERNAL "")

      get_filename_component(fileName ${shared_library_path} NAME)
      set(dstPath "${dstDir}/${fileName}")
      if(NOT EXISTS "${dstPath}")
        cvpkg_info("Copy ${shared_library_filename_ext} file (xxx-config.cmake forget this file, but we copy them!)")
        cvpkg_info("  - package(target): ${pkg}")
        cvpkg_info("  - prop: ${prop}=${shared_library_path}")
        cvpkg_info("  - dstDir: ${dstDir}")
        execute_process(COMMAND ${CMAKE_COMMAND} -E copy ${shared_library_path} ${dstDir})
      endif()
    endforeach()
  endforeach()

  set(cvpkg_already_copied_shared_library_lst "" CACHE INTERNAL "")
  set(${OUTPUT_VAR} ${PLATFORM} PARENT_SCOPE)
endfunction()

#======================================================================
# Recursively copy required DLL files into destination directory
#======================================================================
# Example: 
# cvpkg_copy_required_dlls(testbed ${CMAKE_BINARY_DIR})
# cvpkg_copy_required_dlls(testbed ${CMAKE_BINARY_DIR}/${testbed_output_dir})
#----------------------------------------------------------------------
function(cvpkg_copy_required_dlls targetName dstDir)
  if(NOT (EXISTS ${dstDir}))
    file(MAKE_DIRECTORY ${dstDir})
  elseif(NOT(IS_DIRECTORY ${dstDir}))
    message(FATAL_ERROR "{dstDir} exist but is not an directory!")
  endif()

  cvpkg_get_flatten_requires(${targetName} flatten_pkgs)
  #cvpkg_debug("flatten_pkgs: ${flatten_pkgs}")
  foreach(pkg ${flatten_pkgs})
    # message(STATUS ">>>   pkg is ${pkg} (for dstDir=${dstDir})")
    cvpkg_copy_imported_lib(${pkg} ${dstDir})
  endforeach()
endfunction()

