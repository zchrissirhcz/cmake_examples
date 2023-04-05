cmake_minimum_required(VERSION 3.20)

project(a)

if(CMAKE_SYSTEM_NAME MATCHES "Windows")
  set(SDL2_DIR "D:/artifacts/sdl/2.24.0/windows-x64/cmake")
else()
  set(SDL2_DIR "$ENV{ARTIFACTS_DIR}/sdl2/master/mac-arm64/lib/cmake/SDL2")
endif()
find_package(SDL2 REQUIRED)

if(CMAKE_SYSTEM_NAME MATCHES "Windows")
  set(SDL2_image_DIR "D:/artifacts/sdl_image/2.6.2/windows-x64/cmake")
else()
  set(SDL2_image_DIR "$ENV{ARTIFACTS_DIR}/sdl2_image/master/mac-arm64/SDL2_image.framework/Resources")
endif()
find_package(SDL2_image REQUIRED)


add_executable(testbed
  testbed.cpp
)
target_link_libraries(testbed
  # SDL2_image::SDL2_image
  # SDL2::SDL2

  SDL2_image::SDL2_image-static
  SDL2::SDL2-static
)


add_custom_command(TARGET testbed
    POST_BUILD

    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/frontground.png ${CMAKE_BINARY_DIR}/
)