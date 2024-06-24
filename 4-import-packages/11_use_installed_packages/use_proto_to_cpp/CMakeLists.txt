cmake_minimum_required(VERSION 3.20)
project(use_proto_to_cpp)

include(copy_dll.cmake)

include("find_protobuf_before_3.22.cmake")
include("find_protobuf_since_3.22.cmake")

message(STATUS "!Protobuf_INCLUDE_DIRS: ${Protobuf_INCLUDE_DIRS}")
message(STATUS "!Protobuf_LIBRARIES: ${Protobuf_LIBRARIES}")

protobuf_generate_cpp(AddressBook_PROTO_SRCS AddressBook_PROTO_HDRS ${CMAKE_CURRENT_SOURCE_DIR}/proto/addressbook.proto)

message(STATUS "AddressBook_PROTO_SRCS: ${AddressBook_PROTO_SRCS}")
message(STATUS "AddressBook_PROTO_HDRS: ${AddressBook_PROTO_HDRS}")

add_executable(protobuf_example_write src/protobuf_example_write.cpp ${AddressBook_PROTO_SRCS} ${AddressBook_PROTO_HDRS})
add_executable(protobuf_example_read  src/protobuf_example_read.cpp  ${AddressBook_PROTO_SRCS} ${AddressBook_PROTO_HDRS})
target_include_directories(protobuf_example_write PUBLIC ${CMAKE_CURRENT_BINARY_DIR})
target_include_directories(protobuf_example_read PUBLIC ${CMAKE_CURRENT_BINARY_DIR})

target_link_libraries(protobuf_example_write PUBLIC
  protobuf::libprotobuf
)
target_link_libraries(protobuf_example_read PUBLIC
  protobuf::libprotobuf
)

copy_target_dll(protobuf ${CMAKE_BINARY_DIR})