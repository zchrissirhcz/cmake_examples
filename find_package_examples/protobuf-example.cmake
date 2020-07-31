#set(Protobuf_ROOT "D:/lib/protobuf/3.5.2/x64/vc12") # OK, require cmake>=3.12

set(Protobuf_DIR "D:/lib/protobuf/3.5.2/x64/vc12/cmake" CACHE PATH "") #OK
set(protobuf_MODULE_COMPATIBLE ON CACHE BOOL "") # needed for protobuf_generate_cpp()
find_package(Protobuf REQUIRED CONFIG) # `CONFIG` is required. cmake installation's FindProtobuf.cmake sucks.

include_directories(${Protobuf_INCLUDE_DIRS})
include_directories(${CMAKE_CURRENT_BINARY_DIR})

protobuf_generate_cpp(AddressBook_PROTO_SRCS AddressBook_PROTO_HDRS proto/addressbook.proto)

add_executable(protobuf_example_write src/protobuf_example_write.cpp ${AddressBook_PROTO_SRCS} ${AddressBook_PROTO_HDRS})
add_executable(protobuf_example_read  src/protobuf_example_read.cpp  ${AddressBook_PROTO_SRCS} ${AddressBook_PROTO_HDRS})

target_link_libraries(protobuf_example_write ${Protobuf_LIBRARIES})
target_link_libraries(protobuf_example_read  ${Protobuf_LIBRARIES})

