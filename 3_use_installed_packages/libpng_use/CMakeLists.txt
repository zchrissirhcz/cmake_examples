cmake_minimum_required(VERSION 3.20)

project(libpng_use)


if(ANDROID)
  set(libpng_install_dir "/home/zz/artifacts/libpng/1.6.38-dev/android-arm64")
elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
  set(libpng_install_dir "/home/zz/artifacts/libpng/1.6.38-dev/linux-x64")
endif()

include("${libpng_install_dir}/lib/libpng/libpng16.cmake")
set_target_properties(png
  PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${libpng_install_dir}/include/libpng16
)
set_target_properties(png_static
  PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${libpng_install_dir}/include/libpng16
)

add_executable(testbed testbed.cpp)
target_link_libraries(testbed png)
#target_link_libraries(testbed png_static)
