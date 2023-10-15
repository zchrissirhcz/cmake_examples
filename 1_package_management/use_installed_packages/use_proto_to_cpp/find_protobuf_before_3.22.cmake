
if(CMAKE_SYSTEM_NAME MATCHES "Windows")
  set(Protobuf_LIB_DIR "D:/artifacts/protobuf/v3.21.9/vs2017-x64-shared/lib")
  set(Protobuf_BIN_DIR "D:/artifacts/protobuf/v3.21.9/vs2017-x64-shared/bin")
  set(Protobuf_DIR "D:/artifacts/protobuf/v3.21.9/vs2017-x64-shared/cmake" CACHE PATH "protobuf-config.cmake所在目录")
elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
  #set(Protobuf_DIR "/home/zz/artifacts/protobuf/3.21.9/linux-x64/lib/cmake/protobuf" CACHE PATH "protobuf-config.cmake所在目录")
else()
  message(ERROR "Protobuf_DIR not configured!")
endif()

set(protobuf_MODULE_COMPATIBLE ON CACHE BOOL "") # needed for protobuf_generate_cpp()
find_package(Protobuf REQUIRED) # `CONFIG` is required. cmake installation's FindProtobuf.cmake sucks.
message(STATUS "!Protobuf_INCLUDE_DIRS: ${Protobuf_INCLUDE_DIRS}")
message(STATUS "!Protobuf_LIBRARIES: ${Protobuf_LIBRARIES}")

if(CMAKE_SYSTEM_NAME MATCHES "Windows")
  add_library(protobuf SHARED IMPORTED GLOBAL)
  if(CMAKE_SYSTEM_NAME MATCHES "Windows")
    set_target_properties(protobuf PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${Protobuf_INCLUDE_DIRS}"

      IMPORTED_LOCATION_DEBUG "${Protobuf_BIN_DIR}/libprotobufd.dll"
      IMPORTED_LOCATION_RELEASE "${Protobuf_BIN_DIR}/libprotobuf.dll"
      IMPORTED_LOCATION_MINSIZEREL "${Protobuf_BIN_DIR}/libprotobuf.dll"
      IMPORTED_LOCATION_RELWITHDEBINFO "${Protobuf_BIN_DIR}/libprotobuf.dll"
      IMPORTED_IMPLIB_DEBUG "${Protobuf_LIB_DIR}/libprotobufd.lib"
      IMPORTED_IMPLIB_RELEASE "${Protobuf_LIB_DIR}/libprotobuf.lib"
      IMPORTED_IMPLIB_MINSIZEREL "${Protobuf_LIB_DIR}/libprotobuf.lib"
      IMPORTED_IMPLIB_RELWITHDEBINFO "${Protobuf_LIB_DIR}/libprotobuf.lib"
      
      VERSION 3.21.9
    )
    target_compile_definitions(protobuf INTERFACE PROTOBUF_USE_DLLS)
  else()
    set_target_properties(protobuf PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${Protobuf_INCLUDE_DIRS}"
      IMPORTED_LOCATION "${Protobuf_LIBRARIES}"
      VERSION 3.21.9
    )
  endif()
endif()