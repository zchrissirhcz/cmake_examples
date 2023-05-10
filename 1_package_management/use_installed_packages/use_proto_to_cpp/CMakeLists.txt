cmake_minimum_required(VERSION 3.20)
project(use_proto_to_cpp)

set(CMAKE_CXX_STANDARD 11)

if(CMAKE_SYSTEM_NAME MATCHES "Windows")
  set(Protobuf_LIB_DIR "D:/artifacts/protobuf/v3.21.9/vs2022-x64/lib")
  set(Protobuf_DIR "D:/artifacts/protobuf/v3.21.9/vs2022-x64/cmake" CACHE PATH "protobuf-config.cmake所在目录")
elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
  set(Protobuf_DIR "/home/zz/artifacts/protobuf/3.21.9/linux-x64/lib/cmake/protobuf" CACHE PATH "protobuf-config.cmake所在目录")
else()
  message(FATAL_ERROR "Protobuf_DIR not configured!")
endif()
set(protobuf_MODULE_COMPATIBLE ON CACHE BOOL "") # needed for protobuf_generate_cpp()
find_package(Protobuf REQUIRED CONFIG) # `CONFIG` is required. cmake installation's FindProtobuf.cmake sucks.
message(STATUS "!Protobuf_INCLUDE_DIRS: ${Protobuf_INCLUDE_DIRS}")
message(STATUS "!Protobuf_LIBRARIES: ${Protobuf_LIBRARIES}")

add_library(protobuf SHARED IMPORTED GLOBAL)
if(CMAKE_SYSTEM_NAME MATCHES "Windows")
  set_target_properties(protobuf PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${Protobuf_INCLUDE_DIRS}"

    IMPORTED_LOCATION_DEBUG "${Protobuf_LIB_DIR}/libprotobufd.dll"
    IMPORTED_LOCATION_RELEASE "${Protobuf_LIB_DIR}/libprotobuf.dll"
    IMPORTED_LOCATION_MINSIZEREL "${Protobuf_LIB_DIR}/libprotobuf.dll"
    IMPORTED_LOCATION_RELWITHDEBINFO "${Protobuf_LIB_DIR}/libprotobuf.dll"
    IMPORTED_IMPLIB_DEBUG "${Protobuf_LIB_DIR}/libprotobufd.lib"
    IMPORTED_IMPLIB_RELEASE "${Protobuf_LIB_DIR}/libprotobuf.lib"
    IMPORTED_IMPLIB_MINSIZEREL "${Protobuf_LIB_DIR}/libprotobuf.lib"
    IMPORTED_IMPLIB_RELWITHDEBINFO "${Protobuf_LIB_DIR}/libprotobuf.lib"
    
    VERSION 3.21.9
  )
else()
  set_target_properties(protobuf PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${Protobuf_INCLUDE_DIRS}"
    IMPORTED_LOCATION "${Protobuf_LIBRARIES}"
    VERSION 3.21.9
  )
endif()

protobuf_generate_cpp(AddressBook_PROTO_SRCS AddressBook_PROTO_HDRS ${CMAKE_CURRENT_SOURCE_DIR}/proto/addressbook.proto)

message(STATUS "AddressBook_PROTO_SRCS: ${AddressBook_PROTO_SRCS}")
message(STATUS "AddressBook_PROTO_HDRS: ${AddressBook_PROTO_HDRS}")

add_executable(protobuf_example_write src/protobuf_example_write.cpp ${AddressBook_PROTO_SRCS} ${AddressBook_PROTO_HDRS})
add_executable(protobuf_example_read  src/protobuf_example_read.cpp  ${AddressBook_PROTO_SRCS} ${AddressBook_PROTO_HDRS})
target_include_directories(protobuf_example_write PUBLIC ${CMAKE_CURRENT_BINARY_DIR})
target_include_directories(protobuf_example_read PUBLIC ${CMAKE_CURRENT_BINARY_DIR})

target_link_libraries(protobuf_example_write PUBLIC
  protobuf
)
target_link_libraries(protobuf_example_read PUBLIC
  protobuf
)