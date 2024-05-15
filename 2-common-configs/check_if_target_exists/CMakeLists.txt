# General target
if(TARGET ${targetName})
  message(STATUS "this is an ordinary target")
endif()

# Aliased target
# https://stackoverflow.com/questions/76554484/how-to-check-whether-a-target-is-an-aliased-target-in-cmake
get_property(aliased_target TARGET "${targetName}" PROPERTY ALIASED_TARGET)
if("${aliased_target}" STREQUAL "")
  # is not an alias
else()
  # is an alias
endif()