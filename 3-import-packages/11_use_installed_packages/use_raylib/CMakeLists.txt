cmake_minimum_required(VERSION 3.20)
project(raylib_use)
set(CMAKE_CXX_STANDARD 11)

# use find_package() here...
if(DEFINED ENV{ARTIFACTS_DIR})
  set(ARTIFACTS_DIR "$ENV{ARTIFACTS_DIR}")
else()
  message(WARNING "ARTIFACTS_DIR env var not defined")
endif()

add_executable(testbed
  testbed.cpp
)

# set(raylib_INSTALL_DIR "${ARTIFACTS_DIR}/raylib/4.2.0/mac-arm64")
# set(raylib_INCLUDE_DIR "${raylib_INSTALL_DIR}/include")
# set(raylib_LIB "${raylib_INSTALL_DIR}/lib/libraylib.dylib")

# add_library(raylib::raylib SHARED IMPORTED)
# set_target_properties(raylib::raylib PROPERTIES
#   INTERFACE_INCLUDE_DIRECTORIES "${raylib_INCLUDE_DIR}"
#   IMPORTED_LOCATION_DEBUG "${raylib_LIB}"
#   IMPORTED_LOCATION_RELEASE "${raylib_LIB}"
#   IMPORTED_LOCATION_MINSIZEREL "${raylib_LIB}"
#   IMPORTED_LOCATION_RELWITHDEBINFO "${raylib_LIB}"
# )

# set(easyx_INCLUDE_DIR "${CMAKE_CURRENT_LIST_DIR}/include")
# set(easyx_LIB "${CMAKE_CURRENT_LIST_DIR}/lib/VC2015/x64/EasyXa.lib")

# add_library(easyx STATIC IMPORTED)
# set_target_properties(easyx PROPERTIES
#     INTERFACE_INCLUDE_DIRECTORIES "${easyx_INCLUDE_DIR}"
#     IMPORTED_LOCATION_DEBUG "${easyx_LIB}"
#     IMPORTED_LOCATION_RELEASE "${easyx_LIB}"
#     IMPORTED_LOCATION_MINSIZEREL "${easyx_LIB}"
#     IMPORTED_LOCATION_RELWITHDEBINFO "${easyx_LIB}"
# )

# generated from cmake_parser.py
add_library(raylib::raylib SHARED IMPORTED)
set_target_properties(raylib::raylib PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES "/Users/zz/artifacts/raylib/4.2.0/mac-arm64/include"
  IMPORTED_LOCATION_DEBUG "/Users/zz/artifacts/raylib/4.2.0/mac-arm64/lib/libraylib.dylib"
  IMPORTED_LOCATION_RELEASE "/Users/zz/artifacts/raylib/4.2.0/mac-arm64/lib/libraylib.dylib"
  IMPORTED_LOCATION_MINSIZEREL "/Users/zz/artifacts/raylib/4.2.0/mac-arm64/lib/libraylib.dylib"
  IMPORTED_LOCATION_RELWITHDEBINFO "/Users/zz/artifacts/raylib/4.2.0/mac-arm64/lib/libraylib.dylib"
)

#message(FATAL_ERROR "CMAKE_SYSTEM_PREFIX_PATH: ${CMAKE_SYSTEM_PREFIX_PATH}")

if(0)
  # 由于 raylib 官方的 cmake install 脚本不够完善， 无法简单的使用 find_package 来导入， 需要额外提供一些变量
  # 此外， 由于 raylib 依赖 glfw， 而 raylib 静态编译对应的安装并不会安装 glfw 静态库， 导致静态编译的 raylib 几乎没法用， 需要编动态库
  set(raylib_DIR "${ARTIFACTS_DIR}/raylib/4.2.0/mac-arm64/lib/cmake/raylib")
  message(STATUS "raylib_DIR: ${raylib_DIR}")
  set(PC_RAYLIB_INCLUDE_DIRS "/Users/zz/artifacts/raylib/4.2.0/mac-arm64/include")
  set(PC_RAYLIB_LIBRARY_DIRS "/Users/zz/artifacts/raylib/4.2.0/mac-arm64/lib")
  set(raylib_VERBOSE ON)
  find_package(raylib REQUIRED)
  message(STATUS "raylib_INCLUDE_DIRS: ${raylib_INCLUDE_DIRS}")

  set(glfw3_DIR "/Users/zz/artifacts/raylib/4.2.0/mac-arm64/lib/cmake/glfw3")
  find_package(OpenGL REQUIRED)
  find_package(glfw3 REQUIRED)

  target_link_libraries(testbed PUBLIC
    raylib
    glfw
    ${OPENGL_LIBRARIES}
  )
elseif(0)
  set(raylib_VERBOSE ON)
  set(raylib_DIR "${ARTIFACTS_DIR}/raylib/4.2.0/mac-arm64/lib/cmake/raylib")
  find_package(raylib REQUIRED)
elseif(0)
  # brew install raylib 这样最简单， find_package() 可直接找到
  # 但至于为什么 find_pacakge 能找到 brew install 的，找不到自行编译安装的， 很迷惑。
  set(raylib_VERBOSE ON)
  find_package(raylib REQUIRED)
  target_link_libraries(testbed PUBLIC
    raylib
  )
endif()

find_package(raylib REQUIRED)
target_link_libraries(testbed PUBLIC
  raylib::raylib
)