
set(Protobuf_DIR "/home/zz/artifacts/protobuf/3.21.0/linux-x64/lib/cmake/protobuf" CACHE PATH "protobuf-config.cmake所在目录")
set(protobuf_MODULE_COMPATIBLE ON CACHE BOOL "") # needed for protobuf_generate_cpp()
find_package(Protobuf REQUIRED CONFIG) # `CONFIG` is required. cmake installation's FindProtobuf.cmake sucks.
message(STATUS "!Protobuf_INCLUDE_DIRS: ${Protobuf_INCLUDE_DIRS}")
message(STATUS "!Protobuf_LIBRARIES: ${Protobuf_LIBRARIES}")
add_library(protobuf SHARED IMPORTED GLOBAL)
set_target_properties(protobuf PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES "${Protobuf_INCLUDE_DIRS}"
  IMPORTED_LOCATION "${Protobuf_LIBRARIES}"
  VERSION 3.21.0
)