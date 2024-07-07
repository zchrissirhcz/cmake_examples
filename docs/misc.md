## POSTFIX vs SUFFIX

SUFFIX 指文件扩展名如 `.so`, `.exe`
POSTFIX 指库文件名字中，扩展名前面、库本体名字后面的部分，如 `libhello_d.a` 里的 `_d`.

`CMAKE_DEBUG_POSTFIX` 变量用于设置 library 这类 target 的 `DEBUG_POSTFIX` 属性默认值， 它不会自动设置 executable 这类 target 的 `DEBUG_POSTFIX` 属性默认值。

因此，如果需要给可执行文件添加 postfix， 要手动设置 `DEBUG_POSTFIX` 属性。

给 `CMAKE_DEBUG_POSTFIX` 设置为 "d" 是一个坏主意， 因为库名字可能是 "d" 结尾， 如 "vpd", "msind"。 设置为 "_d" 或 "_debug" 是一个好主意。

最佳实践：
```cmake
set(CMAKE_DEBUG_POSTFIX "_d")
set_target_properties(my_exe PROPERTIES DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})
```

## CMAKE_INSTALL_PREFIX

若 cmake configure 阶段，未指定 `CMAKE_INSTALL_PREFIX`, 则在 `project()` 命令前， 取值为空； 在 `project()` 命令后， 取值为默认值:
```cmake
message(STATUS "[debug] CMAKE_INSTALL_PREFIX: ${CMAKE_INSTALL_PREFIX}") # 取值为空
project(Tutorial VERSION 1.0)
message(STATUS "[debug] CMAKE_INSTALL_PREFIX: ${CMAKE_INSTALL_PREFIX}") # 取值为“默认值”
```

关于 `CMAKE_INSTALL_PREFIX` 的默认值:
- `c:/Program Files (86)/${PROJECT_NAME}` on Windows.
- `c:/Program Files/${PROJECT_NAME}` on Windows.
- `/usr/local` on UNIX platforms.


最佳实践:
```cmake
cmake_minimum_required(VERSION 3.25)
project(Tutorial 1.0)
set(DEFAULT_INSTALL_PREFIX "~/.mypkg/${CMAKE_PROJECT_NAME}")
get_filename_component(DEFAULT_INSTALL_PREFIX "${DEFAULT_INSTALL_PREFIX}" REALPATH)
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX ${DEFAULT_INSTALL_PREFIX})
endif()
```

## INSTALL 和 EXPORT 的概念

cmake 提供了 `install()` 命令，最常用的3个：
- `install(TARGETS ...)`
- `install(FILES ...)`
- `install(EXPORTS ...)`

可以认为 install 阶段，包括了库文件、头文件、指定文件（如license，readme，changelog）的安装， 也包括了 xxx-config.cmake 等文件的生成和安装（这些文件用于外部导入包时使用）

其中 xxx-config.cmake 等文件，不算狭义的 install， 而算是 export 的部分。 

## CMAKE_BUILD_TYPE vs CMAKE_CONFIGURATION_TYPES

CMAKE_BUILD_TYPE 是为 single-config generator 设计和使用的。 常见取值:
- Debug
- Release
- RelWithDebInfo
- MinSizeRel

CMAKE_CONFIGURATION_TYPES 是为 multi-config generator 设计和使用的。 是 `;` 分隔的字符串:
- 默认值是 `Debug;Release;RelWithDebInfo;MinSizeRel`(在第一次`project()`之后有值，在它之前值为空）
- 可以设置为 `Debug;Release`
- 从 CMake 3.22 开始，会从环境变量 `CMAKE_CONFIGURATION_TYPES` 读取，可以设置这一环境变量的值

最佳实践:
```cmake
project(Tutorial VERSION 1.0)
set(CMAKE_BUILD_TYPE Release) # 可手动改为 Debug
set(CMAKE_CONFIGURATION_TYPES "Debug;Release") # 可手动改为 "Debug;RelWithDebInfo"
```