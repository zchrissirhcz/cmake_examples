cmake_minimum_required(VERSION 3.20)
project(SDL2_example)

if(CMAKE_SYSTEM_NAME MATCHES "Windows")
  set(SDL2_DIR "D:/artifacts/sdl/2.24.0/windows-x64/cmake")
else()
  set(SDL2_DIR "$ENV{ARTIFACTS_DIR}/sdl2/master/mac-arm64/lib/cmake/SDL2")
endif()
find_package(SDL2 REQUIRED)
add_executable(testbed
  testbed.cpp
)
target_link_libraries(testbed
  #SDL2::SDL2
  SDL2::SDL2-static
)

add_custom_command(TARGET testbed
    POST_BUILD

    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/hello_world.bmp ${CMAKE_BINARY_DIR}/
)
