cmake_minimum_required(VERSION 3.20)

project(example)

# CMAKE_BUILD_TYPE can be set with any string value
# However, only the following 5 one (case-sensitive) works:
# - Debug 			# debug mode
# - Release 		# release mode
# - MinSizeRel  	# minimal size release mode
# - RelWithDebInfo	# release with debug info
# -                 # empty

#set(CMAKE_BUILD_TYPE Debug) # ok
#set(CMAKE_BUILD_TYPE Release) # ok
#set(CMAKE_BUILD_TYPE "Debug") # ok
#set(CMAKE_BUILD_TYPE "Release") # ok
#set(CMAKE_BUILD_TYPE "MinSizeRel") #ok
#set(CMAKE_BUILD_TYPE "RelWithDebInfo") #ok
#set(CMAKE_BUILD_TYPE DEBUG) # not ok. You may consider using CMAKE_CONFIGURATION_TYPE

message(STATUS ">>> CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
if(CMAKE_BUILD_TYPE MATCHES "Debug")
  message(STATUS ">>> Debug Mode")
  message(STATUS ">>> CMAKE_C_FLAGS_DEBUG: ${CMAKE_C_FLAGS_DEBUG}")
  message(STATUS ">>> CMAKE_CXX_FLAGS_DEBUG: ${CMAKE_CXX_FLAGS_DEBUG}")
  message(STATUS ">>> CMAKE_LINKER_FLAGS_DEBUG: ${CMAKE_LINKER_FLAGS_DEBUG}")
elseif(CMAKE_BUILD_TYPE MATCHES "Release")
  message(STATUS ">>> Release mode")
  message(STATUS ">>> CMAKE_C_FLAGS_RELEASE: ${CMAKE_C_FLAGS_RELEASE}")
  message(STATUS ">>> CMAKE_CXX_FLAGS_RELEASE: ${CMAKE_CXX_FLAGS_RELEASE}")
  message(STATUS ">>> CMAKE_LINKER_FLAGS_RELEASE: ${CMAKE_LINKER_FLAGS_RELEASE}")
elseif(CMAKE_BUILD_TYPE MATCHES "RelWithDebInfo")
  message(STATUS ">>> Release With Debug Info mode")
  message(STATUS ">>> CMAKE_C_FLAGS_RELWITHDEBINFO: ${CMAKE_C_FLAGS_RELWITHDEBINFO}")
  message(STATUS ">>> CMAKE_CXX_FLAGS_RELWITHDEBINFO: ${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
  message(STATUS ">>> CMAKE_LINKER_FLAGS_RELWITHDEBINFO: ${CMAKE_LINKER_FLAGS_RELWITHDEBINFO}")
elseif(CMAKE_BUILD_TYPE MATCHES "MinSizeRel")
  message(STATUS ">>> Minimum Size Release mode")
  message(STATUS ">>> CMAKE_C_FLAGS_MINSIZEREL: ${CMAKE_C_FLAGS_MINSIZEREL}")
  message(STATUS ">>> CMAKE_CXX_FLAGS_MINSIZEREL: ${CMAKE_CXX_FLAGS_MINSIZEREL}")
  message(STATUS ">>> CMAKE_LINKER_FLAGS_MINSIZEREL: ${CMAKE_LINKER_FLAGS_MINSIZEREL}")
elseif(CMAKE_BUILD_TYPE EQUAL "None" OR NOT CMAKE_BUILD_TYPE)
  message(STATUS ">>> Not specified mode")
  message(STATUS ">>> CMAKE_C_FLAGS: ${CMAKE_C_FLAGS}")
  message(STATUS ">>> CMAKE_CXX_FLAGS: ${CMAKE_CXX_FLAGS}")
  message(STATUS ">>> CMAKE_LINKER_FLAGS: ${CMAKE_LINKER_FLAGS}")
endif()


