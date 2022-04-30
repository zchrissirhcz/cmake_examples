cmake_minimum_required(VERSION 3.17)

project(testbed)

# 原始 GLOB
# - 不会递归查找；
# - 新增文件是否自动检测？
#   - 在 Linux / Mac 平台，没指定 generator （则用makefile）时，会自动检测（应该是re-run cmake），能自动检测
#   - 在 Xcode 作为 generator 时，新创建文件，并不会让 GLOB 自动更新
if(0)
    file(GLOB header_files    src/*.h)
    file(GLOB impl_files      src/*.cpp)
endif()

# 普通 GLOB
# - 不会递归查找；
# - 新增文件，通常会自动检测，只要是常见 Generator
#   - 例外情况，是 cmake 新增支持的平台。普通人几乎遇不到的。
#   - 举个例子，最开始是 hello.h 和 hello.cpp ， 后来增加 main.cpp
if(0)
    file(GLOB header_files  CONFIGURE_DEPENDS  src/*.h)
    file(GLOB impl_files    CONFIGURE_DEPENDS  src/*.cpp)
endif()

# 递归 GLOB , 也就是 GLOB_RECURSIVE
# - 搭配 CONFIGURE_DEPENDS 使用 效果更佳
# - 不过，官方说法是， CONFIGURE_DEPENDS 有点慢也不保证完全可靠
#   能手写每个文件，尽量手写吧！（此处 鞭策 cmake 官方 整好点）
if(1)
    file(GLOB_RECURSE header_files  CONFIGURE_DEPENDS  src/*.h)
    file(GLOB_RECURSE impl_files    CONFIGURE_DEPENDS  src/*.cpp)
endif()

message(STATUS "--- header files:")
foreach(f ${header_files})
    message(STATUS ${f})
endforeach()

message(STATUS "--- implementation files:")
foreach(f ${impl_files})
    message(STATUS ${f})
endforeach()

add_executable(testbed
    ${header_files}
    ${impl_files}
)