# CMake Debugging

[TOC]

## 1. CMake Syntax Level Debugging

### 1.1 用 message 命令打印

```cmake
# 常规输出， 相当于 printf
message(STATUS "CMAKE_BUILD_TYPE is: ${CMAKE_BUILD_TYPE}")

# 手动设定 tag/关键字 为 "[debug]"
message("[debug] CMAKE_BUILD_TYPE is: ${CMAKE_BUILD_TYPE}")

# 错误输出， 相当于 fprintf(stderr, ) 加上 exit()/abort, 立即停止运行
message(FATAL_ERROR "-- CMAKE_BUILD_TYPE is: ${CMAKE_BUILD_TYPE}")
```

### 1.2 find_package 输出详细信息

从cmake3.17开始，文档里正式说明支持 `CMAKE_FIND_DEBUG_MODE` 这一cmake变量，设定为 `TRUE` 则打印 `find_package`/`find_program`/`find_file` 等函数的打印过程

```cmake
set(CMAKE_FIND_DEBUG_MODE TRUE)

find_package(...)

set(CMAKE_FIND_DEBUG_MODE FALSE)
```

### 1.3 ccmake/cmake-gui 查看 CMakeCache.txt

toggle 一些 variable 的显示。在 find_package() 失败时候有一些帮助。

### 1.4 查看 <Pkg>Config.cmake 等文件

`find_package()` 后， 使用 package 时的写法往往容易出问题， 写法都是不统一的。
查看 `<Pkg>Config.cmake`以及 `<Pkg>Targets.cmake` 等文件（通常）可以获得正确的 target 写法。

### 1.5 判断 TARGET 是否存在

```cmake
find_package(OpenCL REQUIRED)

if(TARGET OpenCL::OpenCL)
  message(STATUS "Yes, target OpenCL::OpenCL is defined")
else()
  message(STATUS "Nope, not defined OpenCL::OpenCL")
endif()
```

### 1.6 调试 CMake 源码

- [5分钟掌握cmake(7): 通过lldb启动CMake](https://zhuanlan.zhihu.com/p/665611820)
- [5分钟掌握cmake(9): 用VSCode调试CMake源码](https://zhuanlan.zhihu.com/p/666035137)

## 2. Generator/Compiler/Linker level debugging

### 2.1 configure log

在 cmake configure 阶段遇到报错， 可以查看对应的 log 文件 `CMakeConfigureLog.yaml`, 位于 `build/CMakeFiles` 目录下。 该文件包含多个 event， 每个 event 格式基本固定：

- `kind` 字段
- `backtrace` 字段： 调用栈
- `message` 字段： 运行输出
- `checks` 字段（可选）
- `directories` 字段（可选）
- `cmakeVariables` 字段（可选）
- `buildResult` 字段（可选）

例如在交叉编译时， 自行撰写的 `xxx.toolchain.cmake` 文件可能有问题， 导致了 cmake configure 失败， 此时最后一个 event 的描述中看到了问题， 是 `try_compile` 阶段失败了：
```yaml
    kind: "try_compile-v1"
    backtrace:
      - "/home/zz/soft/cmake/3.28.1/share/cmake-3.28/Modules/CMakeDetermineCompilerABI.cmake:57 (try_compile)"
      - "/home/zz/soft/cmake/3.28.1/share/cmake-3.28/Modules/CMakeTestCCompiler.cmake:26 (CMAKE_DETERMINE_COMPILER_ABI)"
      - "CMakeLists.txt:2 (project)"
    checks:
      - "Detecting C compiler ABI info"
    directories:
      source: "/home/zz/work/zzbuild/build-tda4/CMakeFiles/CMakeScratch/TryCompile-hwiDWS"
      binary: "/home/zz/work/zzbuild/build-tda4/CMakeFiles/CMakeScratch/TryCompile-hwiDWS"
    cmakeVariables:
      CMAKE_C_FLAGS: ""
      CMAKE_C_FLAGS_DEBUG: "-g"
      CMAKE_EXE_LINKER_FLAGS: ""
      CMAKE_SYSROOT: "/home/zz/soft/toolchains/tda4/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu/aarch64-none-linux-gnu/libc"
    buildResult:
      variable: "CMAKE_C_ABI_COMPILED"
      cached: true
      stdout: |
      exitCode: 1
```

### 2.2 生成 compile_commands.json

```cmake
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
```

或在 `~/.zsh`/`~/.pathrc` 里设置:
```bash
export CMAKE_EXPORT_COMPILE_COMMANDS=1
```

### 2.3 verbose 输出

CMakeLists.txt
```cmake
cmake_minimum_required(VERSION 3.20)
project(blabla)

set(CMAKE_VERBOSE_MAKEFILE ON) # !! 增加这句
```
随后执行 make/ninja 时会生成 `link.txt` 或 `linkLibs.rsp` 文件, 里面列出了链接使用的命令或部分参数.

或手动修改 `CMakeCache.txt` 中 `CMAKE_VERBOSE_MAKEFILE` 为 `ON`:
```cmake
//If this value is on, makefiles will be generated without the
// .SILENT directive, and all commands will be echoed to the console
// during the make.  This is useful for debugging only. With Visual
// Studio IDE projects all commands are done without /nologo.
CMAKE_VERBOSE_MAKEFILE:BOOL=ON
```

### 2.4 查看 ld 链接器详细输出

```cmake
target_link_options(testbed PRIVATE -Wl,--verbose)
```
