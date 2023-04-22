message(STATUS "================================================================================")
message(STATUS "  CMake Configure Summary    ")
message(STATUS "--------------------------------------------------------------------------------")
message(STATUS "  Author:   Zhuo Zhang (imzhuo#foxmail.com)")
message(STATUS "  Create:   2023.02.15")
message(STATUS "  Modified: 2023.04.22")
message(STATUS "  Usage:    include(summary.cmake) # put in bottom of Root CMakeLists.txt")
message(STATUS "================================================================================")

#------------------------------
# CMake information
#------------------------------
message(STATUS "CMake information:")
message(STATUS "  - CMake version:              ${CMAKE_VERSION}")
message(STATUS "  - CMake generator:            ${CMAKE_GENERATOR}")
message(STATUS "  - CMake building tools:       ${CMAKE_BUILD_TOOL}")
message(STATUS "  - Target System:              ${CMAKE_SYSTEM_NAME}")
message(STATUS "")

#------------------------------
# C/C++ Compilier information
#------------------------------
message(STATUS "Toolchain information:")
message(STATUS "  Cross compiling: ${CMAKE_CROSSCOMPILING}")
message(STATUS "  C/C++ compilier:")
message(STATUS "    - C   standard version:     C${CMAKE_C_STANDARD}")
message(STATUS "    - C   standard required:    ${CMAKE_C_STANDARD_REQUIRED}")
message(STATUS "    - C   standard extensions:  ${CMAKE_C_EXTENSIONS}")
message(STATUS "    - C   compilier version:    ${CMAKE_C_COMPILER_VERSION}")
message(STATUS "    - C   compilier:            ${CMAKE_C_COMPILER}")
message(STATUS "    - C++ standard version:     C++${CMAKE_CXX_STANDARD}")
message(STATUS "    - C++ standard required:    ${CMAKE_CXX_STANDARD_REQUIRED}")
message(STATUS "    - C++ standard extensions:  ${CMAKE_CXX_EXTENSIONS}")
message(STATUS "    - C++ compilier version:    ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "    - C++ compilier:            ${CMAKE_CXX_COMPILER}")
message(STATUS "")

#------------------------------
# C/C++ Compilation Information
#------------------------------
string(TOUPPER "${CMAKE_BUILD_TYPE}" capitalized_build_type)

message(STATUS "C/C++ Compilation information")
message(STATUS "    - CMAKE_BUILD_TYPE:         ${CMAKE_BUILD_TYPE}")
message(STATUS "    - CONFIG:                   ${capitalized_build_type}")
message(STATUS "    - CMAKE_CXX_FLAGS(for all build types): ${CMAKE_CXX_FLAGS}")
set(summary_cxx_flags "${CMAKE_CXX_FLAGS}")

if(NOT (CMAKE_BUILD_TYPE EQUAL "None" OR NOT CMAKE_BUILD_TYPE))
  message(STATUS "    - CMAKE_CXX_FLAGS_<CONFIG>: CMAKE_CXX_FLAGS_${capitalized_build_type} : ${CMAKE_CXX_FLAGS_${capitalized_build_type}}")
  set(summary_cxx_flags "${summary_cxx_flags} ${CMAKE_CXX_FLAGS_${capitalized_build_type}}")
endif()

# e.g. -Werror=return-type
get_directory_property(summary_detected_global_compile_options COMPILE_OPTIONS)
message(STATUS "    - Global Compile Options(via `add_compile_options()`): ${summary_detected_global_compile_options}")
set(summary_cxx_flags "${summary_cxx_flags} ${summary_detected_global_compile_options}")

# e.g. -I/some/dir
get_directory_property(summary_detected_global_include_directories INCLUDE_DIRECTORIES)
set(styled_global_include_directories "")
foreach(include_directory ${summary_detected_global_include_directories})
  set(styled_global_include_directories "-I${include_directory} ${styled_global_include_directories}")
endforeach()
set(summary_cxx_flags "${styled_global_include_directories} ${summary_cxx_flags}")
message(STATUS "    - Global Include Directories(via `include_directories()`): ${summary_detected_global_include_directories}")

# e.g. -Dfoo=123
get_directory_property(summary_detected_global_compile_definitions COMPILE_DEFINITIONS)
set(styled_global_compile_definitions "")
foreach(compile_definition ${summary_detected_global_compile_definitions})
  #message("-D${compile_definition}")
  set(styled_global_compile_definitions "-D${compile_definition} ${styled_global_compile_definitions}")
endforeach()
set(summary_cxx_flags "${styled_global_compile_definitions} ${summary_cxx_flags}")
message(STATUS "    - Global Compile Definitions: ${styled_global_compile_definitions}")
message(STATUS "      (via `add_compile_definitions()`, `add_definitions()`)")

message(STATUS "    - Final CXX FLAGS: ${summary_cxx_flags}")
message(STATUS "      (which consists of {add_compile_definitions(), CMAKE_CXX_FLAGS, CMAKE_CXX_FLAGS_<CONFIG>, add_compile_options()}")
message(STATUS "    See ${CMAKE_BINARY_DIR}/compile_commands.json for full details")
message(STATUS "")

#------------------------------
# C/C++ Linking Information
#------------------------------
message(STATUS "C/C++ Linking information")
# e.g. -L/some/dir
get_directory_property(summary_detected_global_link_directories LINK_DIRECTORIES)
message(STATUS "    - Global Link Directories(via `link_directories()`): ${summary_detected_global_link_directories}")

# e.g. -llibname
get_directory_property(summary_detected_global_link_options LINK_OPTIONS)
message(STATUS "    - Global Link Options(via `add_link_options()`): ${summary_detected_global_link_options}")

message(STATUS "    See ${CMAKE_BINARY_DIR}/CMakeFiles/\${target_name}.dir/link.txt) for full details")
message(STATUS "")

#------------------------------
# Target list
#------------------------------
function(summary_get_all_targets var)
  set(targets)
  summary_get_all_targets_recursive(targets ${CMAKE_CURRENT_SOURCE_DIR})
  set(${var} ${targets} PARENT_SCOPE)
endfunction()

macro(summary_get_all_targets_recursive targets dir)
  get_property(subdirectories DIRECTORY ${dir} PROPERTY SUBDIRECTORIES)
  foreach(subdir ${subdirectories})
    summary_get_all_targets_recursive(${targets} ${subdir})
  endforeach()

  get_property(current_targets DIRECTORY ${dir} PROPERTY BUILDSYSTEM_TARGETS)
  list(APPEND ${targets} ${current_targets})
endmacro()

summary_get_all_targets(all_targets)
message(STATUS "List of targets (name, type, link command file):")
foreach(target_name ${all_targets})
  get_target_property(target_type ${target_name} TYPE)
  message(STATUS "  ${target_name}")
  message(STATUS "    - target type:    ${target_type}")

  get_property(tgt_binary_dir TARGET ${target_name} PROPERTY BINARY_DIR)
  message(STATUS "    - binary dir:     ${tgt_binary_dir}")

  if(${CMAKE_GENERATOR} STREQUAL "Unix Makefiles")
    message(STATUS "    - link command:   ${tgt_binary_dir}/CMakeFiles/${target_name}.dir/link.txt")
  elseif(${CMAKE_GENERATOR} STREQUAL "Ninja")
    message(STATUS "    - link command:   ${CMAKE_BINARY_DIR}/build.ninja")
  endif()

  get_property(tgt_compile_flags TARGET ${target_name} PROPERTY COMPILE_FLAGS)
  if(tgt_compile_flags)
    message(STATUS "    - compile flags: ${tgt_compile_flags}")
  endif()

  get_property(tgt_compile_options TARGET ${target_name} PROPERTY COMPILE_OPTIONS)
  if(tgt_compile_options)
    message(STATUS "    - compile options: ${tgt_compile_options}")
  endif()
    
  get_property(tgt_compile_definitions TARGET ${target_name} PROPERTY COMPILE_DEFINITIONS)
  if(tgt_compile_definitions)
    message(STATUS "    - compile definitions: ${tgt_compile_definitions}")
  endif()

  get_property(tgt_link_options TARGET ${target_name} PROPERTY LINK_OPTIONS)
  if(tgt_link_options)
    message(STATUS "    - link options: ${tgt_link_options}")
  endif()

  get_property(tgt_link_flags TARGET ${target_name} PROPERTY LINK_FLAGS)
  if(tgt_link_flags)
    message(STATUS "    - link flags: ${tgt_link_flags}")
  endif()
endforeach()
message(STATUS "")


#------------------------------
# Misc stuffs
#------------------------------
message(STATUS "Other information:")
# show building install path
message(STATUS "  Package install path:         ${CMAKE_INSTALL_PREFIX}")
message(STATUS "")

message(STATUS "  OpenMP:")
if(OpenMP_FOUND)
  message(STATUS "    - OpenMP was found:         YES")
  message(STATUS "    - OpenMP version:           ${OpenMP_C_VERSION}")
else()
  message(STATUS "    - OpenMP was found:         NO")
  endif()
message(STATUS "")

