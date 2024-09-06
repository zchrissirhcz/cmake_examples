cmake_minimum_required(VERSION 3.20)
project(x)

add_subdirectory(protobuf)

add_executable(hello hello.cpp)

function(copy_target_dll targetName dstDir)
  set(prop_lst "IMPORTED_LOCATION;IMPORTED_LOCATION_DEBUG;IMPORTED_LOCATION_RELEASE")
  set(pkg ${targetName})
  foreach(prop ${prop_lst})
    #message(STATUS "!! prop: ${prop}")
    get_target_property(dll_path ${pkg} ${prop})
    if(dll_path)
      message("copy package ${pkg} DLL file: ${dll_path}")
      execute_process(COMMAND ${CMAKE_COMMAND} -E copy ${dll_path} ${CMAKE_BINARY_DIR})
    endif()
  endforeach()
endfunction()

copy_target_dll(protobuf ${CMAKE_BINARY_DIR})