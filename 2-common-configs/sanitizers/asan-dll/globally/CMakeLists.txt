cmake_minimum_required(VERSION 3.29)
project(demo)

#------------------------------------------------------------
# enable asan
#------------------------------------------------------------
# specify asan compile and link options
add_compile_options(/fsanitize=address)
add_link_options(/fsanitize=address)

# Remove /INCREMENTAL from global linker flags
set(LINKER_FLAGS_VARS
  "CMAKE_EXE_LINKER_FLAGS"
  "CMAKE_SHARED_LINKER_FLAGS"
  "CMAKE_MODULE_LINKER_FLAGS"
)
foreach(LINKER_FLAG_VAR ${LINKER_FLAGS_VARS})
  if(DEFINED ${LINKER_FLAG_VAR})
    string(REPLACE "/INCREMENTAL" "" NEW_LINKER_FLAGS "${${LINKER_FLAG_VAR}}")
    set(${LINKER_FLAG_VAR} "${NEW_LINKER_FLAGS}" CACHE STRING "Global linker flags" FORCE)
  endif()
endforeach()

#------------------------------------------------------------
# find opencv
#------------------------------------------------------------
set(OpenCV_DIR "C:/pkgs/opencv/build/x64/vc16/lib")
find_package(OpenCV REQUIRED)

#------------------------------------------------------------
# add opencv dll directory and asan dll directory, to runtime PATH, for each target
#------------------------------------------------------------
get_filename_component(OpenCV_BIN_DIR "${OpenCV_DIR}/../bin" ABSOLUTE)
get_filename_component(CXX_COMPILER_DIR ${CMAKE_CXX_COMPILER} DIRECTORY)
message("[debug] CMAKE_VS_DEBUGGER_ENVIRONMENT: ${CMAKE_VS_DEBUGGER_ENVIRONMENT}")
set(CMAKE_VS_DEBUGGER_ENVIRONMENT "PATH=${CXX_COMPILER_DIR};${OpenCV_BIN_DIR};%PATH%")

#------------------------------------------------------------
# create a target
#------------------------------------------------------------
add_executable(demo
  test.cpp
)
target_link_libraries(demo PUBLIC
  ${OpenCV_LIBS}
)