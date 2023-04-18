cmake_minimum_required(VERSION 3.20)
project(x)

set(CMAKE_CXX_STANDARD 11)

set(Protobuf_DIR "/home/zz/artifacts/protobuf/3.21.9/linux-x64/lib/cmake/protobuf" CACHE PATH "protobuf-config.cmake所在目录")
set(protobuf_MODULE_COMPATIBLE ON CACHE BOOL "") # needed for protobuf_generate_cpp()
find_package(Protobuf REQUIRED CONFIG) # `CONFIG` is required. cmake installation's FindProtobuf.cmake sucks.
message(STATUS "!Protobuf_INCLUDE_DIRS: ${Protobuf_INCLUDE_DIRS}")
message(STATUS "!Protobuf_LIBRARIES: ${Protobuf_LIBRARIES}")
add_library(protobuf SHARED IMPORTED GLOBAL)
set_target_properties(protobuf PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES "${Protobuf_INCLUDE_DIRS}"
  IMPORTED_LOCATION "${Protobuf_LIBRARIES}"
  VERSION 3.21.9
)

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