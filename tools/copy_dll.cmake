# Author: Zhuo Zhang <imzhuo@foxmail.com>
# Homepage: https://github.com/zchrissirhcz
# Last update: 2023-07-02 23:36:12

function(copy_target_dll targetName dstDir)
  set(prop_lst "IMPORTED_LOCATION;IMPORTED_LOCATION_DEBUG;IMPORTED_LOCATION_RELEASE")
  
  if(NOT (TARGET ${targetName}))
    return()
  endif()

  get_property(aliased_target TARGET "${targetName}" PROPERTY ALIASED_TARGET)
  if("${aliased_target}" STREQUAL "")
    # is not an alias
    if(NOT (TARGET ${targetName}))
      return()
    endif()
  else()
    # is an alias
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

# Usage example:
# include(copy_dll.cmake)
# copy_target_dll(pthreads ${CMAKE_BINARY_DIR})