
set(CMAKE_CXX_STANDARD 14)

set(protobuf_MODULE_COMPATIBLE ON CACHE BOOL "") # needed for protobuf_generate_cpp()

# since protobuf 3.22, it requires abseil. cmake links to abseil automatically
find_package(Protobuf REQUIRED)

