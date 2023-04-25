#======================================================================
# Author:   Zhuo Zhang <imzhuo@foxmail.com>
# Created:  2023.04.23 13:00:00
# Modified: 2023-04-25 09:18:39
#======================================================================


#======================================================================
# determine if a list is empty
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
# determine if item is in the list
#======================================================================
# Example: 
# cvpkg_is_item_in_list(testbed_requires "protobuf" protobuf_in_the_lst)
# message(STATUS "protobuf_in_the_lst: ${protobuf_in_the_lst}")
# 
# cvpkg_is_item_in_list(testbed_requires "opencv" opencv_in_the_lst)
# message(STATUS "opencv_in_the_lst: ${opencv_in_the_lst}")
#----------------------------------------------------------------------
function(cvpkg_is_item_in_list the_list the_item ret)
  list(FIND ${the_list} ${the_item} index)
  if(index EQUAL -1)
    set(${ret} FALSE PARENT_SCOPE)
  else()
    set(${ret} TRUE PARENT_SCOPE)
  endif()
endfunction()

#======================================================================
# 4. Recursively get required packages for a package. No duplicated result.
#======================================================================
# Example: 
# cvpkg_get_flatten_requires(testbed flatten_pkgs)
# message(STATUS "flatten_pkgs: ${flatten_pkgs}")
#----------------------------------------------------------------------
function(cvpkg_get_flatten_requires input_pkg the_result)
  list(LENGTH input_pkg input_pkg_length)
  if(NOT (${input_pkg_length} EQUAL 1))
    message(FATAL_ERROR "input_pkg should be single element list")
  endif()

  set(visited_pkgs "")
  set(pkg_stack ${input_pkg})
  while(TRUE)
    cvpkg_is_list_empty(pkg_stack pkg_stack_empty)
    if(${pkg_stack_empty})
      break()
    endif()

    #message(STATUS "pkg_stack: ${pkg_stack}")
    # pop the last element
    list(POP_BACK pkg_stack pkg)
    #message(STATUS "pkg: ${pkg}")

    # mark the element as visited
    cvpkg_is_item_in_list(visited_pkgs "${pkg}" pkg_visited)
    if(NOT ${pkg_visited})
      #message(STATUS " visiting ${pkg}")
      list(APPEND visited_pkgs ${pkg})

      # traverse it's required dependencies and put into pkg_stack
      get_target_property(subpkgs ${pkg} LINK_LIBRARIES)
      #message(STATUS "LINK_LIBRARIES: ${subpkgs}")
      if(subpkgs)
        foreach(subpkg ${subpkgs})
          if(TARGET ${subpkg}) # if called target_link_libraries() more than once, subpkgs contains stuffs like `::@(000001FAFA8C75C0)`
            #message(STATUS "  subpkg: ${subpkg}")
            list(APPEND pkg_stack ${subpkg})
          endif()
        endforeach()
      endif()

      get_target_property(subpkgs ${pkg} INTERFACE_LINK_LIBRARIES)
      #message(STATUS "INTERFACE_LINK_LIBRARIES: ${subpkgs}")
      if(subpkgs)
        foreach(subpkg ${subpkgs})
          if(TARGET ${subpkg}) # if called target_link_libraries() more than once, subpkgs contains stuffs like `::@(000001FAFA8C75C0)`
            #message(STATUS "  subpkg: ${subpkg}")
            list(APPEND pkg_stack ${subpkg})
          endif()
        endforeach()
      endif()
    endif()

  endwhile()

  list(POP_FRONT visited_pkgs visited_pkgs)
  set(${the_result} ${visited_pkgs} PARENT_SCOPE)
endfunction()


#======================================================================
# Copy imported lib for all build types
# Should only be used for shared libs, e.g. .dll, .so, .dylib
#======================================================================
# Example: 
# cvpkg_copy_imported_lib(testbed ${CMAKE_BINARY_DIR}/${testbed_output_dir})
#----------------------------------------------------------------------
function(cvpkg_copy_imported_lib targetName dstDir)
  set(prop_lst "IMPORTED_LOCATION;IMPORTED_LOCATION_DEBUG;IMPORTED_LOCATION_RELEASE")
  
  if(NOT (TARGET ${targetName}))
    return()
  endif()

  get_target_property(pkg_type ${targetName} TYPE)
  if(NOT (${pkg_type} STREQUAL "SHARED_LIBRARY"))
    return()
  endif()

  set(pkg ${targetName})
  foreach(prop ${prop_lst})
    #message(STATUS "!! prop: ${prop}")
    get_target_property(dll_path ${pkg} ${prop})
    if(dll_path)
      message(STATUS "Copy DLL file:")
      message(STATUS "  - package(target): ${pkg}")
      message(STATUS "  - prop: ${prop}=${dll_path}")
      message(STATUS "  - dstDir: ${dstDir}")
      execute_process(COMMAND ${CMAKE_COMMAND} -E copy ${dll_path} ${dstDir})
    endif()
  endforeach()
endfunction()

#======================================================================
# Recursively copy required DLL files into destination directory
#======================================================================
# Example: 
# cvpkg_copy_required_dlls(testbed ${CMAKE_BINARY_DIR})
# cvpkg_copy_required_dlls(testbed ${CMAKE_BINARY_DIR}/${testbed_output_dir})
#----------------------------------------------------------------------
function(cvpkg_copy_required_dlls targetName dstDir)
  cvpkg_get_flatten_requires(testbed flatten_pkgs)
  message(STATUS "flatten_pkgs: ${flatten_pkgs}")
  foreach(pkg ${flatten_pkgs})
   cvpkg_copy_imported_lib(${pkg} ${dstDir})
  endforeach()
endfunction()

