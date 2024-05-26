if(MSVC)
  target_link_options(your_executable PRIVATE "/STACK:10485760") # 10MB
endif()