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
set(CVPKG_VERSION "2023-06-26 17:40:05")
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
# 4. Recursively get required packages for a package. No duplicated.
#======================================================================
# Example: 
# cvpkg_get_flatten_requires(testbed flatten_pkgs)
# message(STATUS "flatten_pkgs: ${flatten_pkgs}")
#----------------------------------------------------------------------
function(cvpkg_get_flatten_requires input_pkg the_result)
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
      cvpkg_debug("LINK_LIBRARIES: ${subpkgs}")
      if(subpkgs)
        foreach(subpkg ${subpkgs})
          if(TARGET ${subpkg}) # if called target_link_libraries() more than once, subpkgs contains stuffs like `::@(000001FAFA8C75C0)`
            cvpkg_debug("  subpkg: ${subpkg}")
            list(APPEND pkg_stack ${subpkg})
          endif()
        endforeach()
      endif()

      get_target_property(subpkgs ${pkg} INTERFACE_LINK_LIBRARIES)
      cvpkg_debug("INTERFACE_LINK_LIBRARIES: ${subpkgs}")
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
  set(${the_result} ${visited_pkgs} PARENT_SCOPE)
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
              cvpkg_info("Copy ${shared_library_filename_ext} file (for static library, we detect and copy them!)")
              cvpkg_info("  - static_library_path: ${prop}=${static_library_path}")
              cvpkg_info("  - shared_library_path: ${shared_library_path}")
              #cvpkg_info("  - cvpkg_already_copied_shared_library_lst: ${cvpkg_already_copied_shared_library_lst}")
              cvpkg_info("  - dstDir: ${dstDir}")

              list(APPEND cvpkg_already_copied_shared_library_lst "${shared_library_path}")
              set(cvpkg_already_copied_shared_library_lst  "${cvpkg_already_copied_shared_library_lst}" CACHE INTERNAL "")
              execute_process(COMMAND ${CMAKE_COMMAND} -E copy ${shared_library_path} ${dstDir})
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
    get_target_property(shared_library_path ${pkg} ${prop})
    if(shared_library_path)
      if("${shared_library_path}" IN_LIST cvpkg_already_copied_shared_library_lst)
        continue()
      endif()
      list(APPEND cvpkg_already_copied_shared_library_lst "${shared_library_path}")
      set(cvpkg_already_copied_shared_library_lst  "${cvpkg_already_copied_shared_library_lst}" CACHE INTERNAL "")
      cvpkg_info("Copy ${shared_library_filename_ext} file")
      cvpkg_info("  - package(target): ${pkg}")
      cvpkg_info("  - prop: ${prop}=${shared_library_path}")
      cvpkg_info("  - dstDir: ${dstDir}")
      execute_process(COMMAND ${CMAKE_COMMAND} -E copy ${shared_library_path} ${dstDir})
    endif()
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
      cvpkg_info("Copy ${shared_library_filename_ext} file (xxx-config.cmake forget this file, but we copy them!)")
      cvpkg_info("  - package(target): ${pkg}")
      cvpkg_info("  - prop: ${prop}=${shared_library_path}")
      cvpkg_info("  - dstDir: ${dstDir}")
      execute_process(COMMAND ${CMAKE_COMMAND} -E copy ${shared_library_path} ${dstDir})
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
  message(STATUS "flatten_pkgs: ${flatten_pkgs}")
  foreach(pkg ${flatten_pkgs})
    message(STATUS ">>>   pkg is ${pkg} (for dstDir=${dstDir})")
    cvpkg_copy_imported_lib(${pkg} ${dstDir})
  endforeach()
endfunction()

