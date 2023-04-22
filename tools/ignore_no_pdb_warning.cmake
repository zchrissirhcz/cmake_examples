# last update: 2023/04/22

#set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "/ignore:4099")
if(CMAKE_SYSTEM_NAME MATCHES "Windows")
  add_link_options("/ignore:4099")
endif()