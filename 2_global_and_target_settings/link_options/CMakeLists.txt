# globally
if(CMAKE_SYSTEM_NAME MATCHES "Windows")
  add_link_options("/ignore:4099")
endif()

# per-target
if(CMAKE_SYSTEM_NAME MATCHES "Windows")
  set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "/ignore:4099")
endif()