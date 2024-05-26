if(NOT WIN32 OR WINDOWS_STORE)
  return()
endif()

find_path(VLD_INCLUDE_DIR
  vld.h
  HINTS "$ENV{ProgramFiles}/Visual Leak Detector/include"
  HINTS "$ENV{ProgramFiles} (x86)/Visual Leak Detector/include"
  NO_DEFAULT_PATH
  )
if(CMAKE_SIZEOF_VOID_P EQUAL 4)
  set(VLD_LIB_SUFFIX Win32)
else()
  set(VLD_LIB_SUFFIX Win64)
endif()
find_path(VLD_LIBRARY_DIR
  vld.lib
  HINTS "$ENV{ProgramFiles}/Visual Leak Detector/lib/${VLD_LIB_SUFFIX}"
  HINTS "$ENV{ProgramFiles} (x86)/Visual Leak Detector/lib/${VLD_LIB_SUFFIX}"
  )
unset(VLD_LIB_SUFFIX)
if(VLD_INCLUDE_DIR AND VLD_LIBRARY_DIR)
  set(VLD_FOUND ON)
  add_definitions(-DHAVE_VLD)
  include_directories(${VLD_INCLUDE_DIR})
  link_directories(${VLD_LIBRARY_DIR})
endif()
