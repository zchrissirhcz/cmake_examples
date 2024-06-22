cmake_minimum_required(VERSION 3.25)
project(say_hello)

add_library(hello STATIC IMPORTED GLOBAL)
set(hello_root "${CMAKE_CURRENT_SOURCE_DIR}/../prebuilt/hello")
set_target_properties(hello PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES "${hello_root}/inc"
  IMPORTED_LOCATION_DEBUG "${hello_root}/lib/vs2022-x64/Debug/hello_d.lib"
  IMPORTED_LOCATION_RELEASE "${hello_root}/lib/vs2022-x64/Release/hello.lib"
  IMPORTED_LOCATION_MINSIZEREL "${hello_root}/lib/vs2022-x64/Release/hello.lib"
  IMPORTED_LOCATION_RELWITHDEBINFO "${hello_root}/lib/vs2022-x64/Release/hello.lib"
  VERSION 0.0.1
)

add_executable(say_hello say_hello.cpp)
target_link_libraries(say_hello PRIVATE hello)