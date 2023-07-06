# globally
if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
  add_compile_options("/EHsc")
endif()

# per-target
if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
  set_target_properties(hello PROPERTIES COMPILE_FLAGS "/EHsc")
endif()