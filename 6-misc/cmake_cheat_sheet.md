# CMake Cheat Sheet

[TOC]

## 1. variable

https://cmake.org/cmake/help/v3.20/manual/cmake-variables.7.html

- Ordinary
```cmake
set(HELLO "hello world")  # define
message(STATUS "HELLO's value: ${HELLO}") # print
```

- Cache variable

官方文档：https://cmake.org/cmake/help/v3.20/variable/CACHE.html

cmake cache variable 指的是有默认值（预设值）的变量，可以提供新的值来覆盖。
```cmake
set(OpenCV_DIR "/usr/lib/x86_64-linux-gnu/cmake/opencv4" CACHE PATH "这里写对于此缓存变量的注释")
message(STATUS "OpenCV_DIR: ${OpenCV_DIR}")
```

Environment variable:
```cmake
message(STATUS "ENV{PATH}: $ENV{PATH}")
```

**系统内置变量**
例如 `CMAKE_CXX_FLAGS`, `CMAKE_SOURCE_DIR`, `CMAKE_BINARY_DIR`, `CMAKE_CURRENT_SOURCE_DIR`, `CMAKE_CURRENT_BINARY_DIR` 等。

**打印变量**
前面提到的， 在 CMakeLists.txt 里调用 `set()` 和 `message()` 实现变量的定义与打印，然后按入门起手式30秒里提到的两种编译命令，可以执行输出。

还可以用脚本方式 (`cmake -P xxx.cmake`)， 快速加以验证：
print_cache_var.cmake：
```cmake
set(OpenCV_DIR "/usr/lib/x86_64-linux-gnu/cmake/opencv4" CACHE PATH "这里写对于此缓存变量的注释")
message(STATUS "OpenCV_DIR: ${OpenCV_DIR}")
```

执行 `cmake -P print_cache_var.cmake`：
```
-- OpenCV_DIR: /usr/lib/x86_64-linux-gnu/cmake/opencv4
```

可使用 `-D<var>=<value>` 临时传入变量：
执行 `cmake -DOpenCV_DIR=/home/zz/lib/opencv/4.5.2/lib/cmake/opencv4 -P print_cache_var.cmake`：
```bash
-- OpenCV_DIR: /home/zz/lib/opencv/4.5.2/lib/cmake/opencv4
```

执行 `cmake -P print_cache_var.cmake -DOpenCV_DIR=/home/zz/lib/opencv/4.5.2/lib/cmake/opencv4`:
```bash
-- OpenCV_DIR: /usr/lib/x86_64-linux-gnu/cmake/opencv4
```

其中 `-D<var>=<value>` 表示临时传入值，能够覆盖原有的值（如果原来有同名变量），或新创建变量（如果先前不存在）。注意 `-D` 在 `-P` 后设定则不生效。

## 2. Coding Style Style

### Naming
关键字(如set/if)，大写、小写、混合大小写，都不会报错；此时应主动改为小写

内置变量(如CMAKE_SOURCE_DIR)只能用大写

自定义的变量或函数名， 不做限制。

举例：

```cmake
set(var "123")   # good
SET(var "123")   # bad
SeT(var "123")   # very bad
```

列出常见的关键字：
- `set`
- `list`
- `if`, `else`, `elseif`, `endif`
- `foreach`, `endforeach`
- `function`, `endfunction`
- `macro`, `endmacro`

列出常见的 CMake 内置变量：
- `CMAKE_SOURCE_DIR`
- `CMAKE_BINARY_DIR`
- `CMAKE_CURRENT_FILE`
- `PROJECT_SOURCE_DIR`
- `CMAKE_C_FLAGS`
- `CMAKE_CXX_FLAGS`
- `CMAKE_BUILD_TYPE`
- `CMAKE_LINKER_FLAGS`

### Indentation
Prefer indent with spaces rather than tabs.

Prefer using `EditorConfig` plugin.

Keeping same indentation style rather than mixed.

Recommend no space between `set` and `(`, `if` and `(`, etc.
```cmake
set(my_srcs "1.cpp") # good
set (my_srcs "1.cpp") # bad
```

```cmake
# good
if(CMAKE_SYSTEM_NAME MATCHES "Windows")
  message(STATUS "windows")
endif()

# bad
if (CMAKE_SYSTEM_NAME MATCHES "Windows")
  message(STATUS "windows")
endif()
```

### Modern CMake as much as possible
cmake 是一个有着多年历史的软件； 类似于 C++ 分为 classical c++ 和 modern c++， cmake 也区分 classifical cmake 和 modern cmake。
- classical cmake：古典 cmake，各种设置往往是全局的，不能说不work，只能说潜在的坑比较多，不够灵活
- modern cmake：类似于 object orientated 的想法，尽量减少全局设定，尽量按每个 target 设定， target 属性有 PRIVATE/PUBLIC/INTERFACE 这样的修饰关键字

通常来说，能用最新 cmake 就用最新版的。通常是兼容老版本的。

这里先不具体展开， 大概有个印象（因为能展开的细节太多了）


## 3. Good Global Settings

设置 C++11 语言标准:
```cmake
set(CMAKE_CXX_STANDARD 11)
```

设置构建类型:
```cmake
set(CMAKE_BUILD_TYPE Release)
#set(CMAKE_BUILD_TYPE Debug)
```

生成 compile_commands.json (非MSVC)
```cmake
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
```

## 4. Importing dependeny

### find_package()
Set `XXX_DIR` to the directory that contains `XXXConfig.cmake` or `xxx-config.cmake`.

Examples:
- apt installed opencv:
```bash
sudo apt install libopencv-dev
dpkg -L libopencv-dev | grep 'OpenCVConfig.cmake' # /usr/lib/x86_64-linux-gnu/cmake/opencv4/
```
- manuall compiled opencv:
```bash
find /home/zz/soft/opencv-4.5.2 -name 'OpenCVConfig.cmake' | xargs realpath | xargs dirname
```
- ncnn:
```bash
set(ncnn_DIR "..." CACHE PATH "Directory that contains ncnnConfig.cmake")
find_package(ncnn REQUIRED)
target_link_libraries(testbed ncnn)
```

### `xxx.cmake` or `FindXXX.cmake`
有头文件，有库文件，但是没 xxx.cmake 或 FindXXX.cmake

#### Brute Force
```cmake
set(hello_inc_dir "/path/to/hello_include")
set(hello_lib "/path/to/hello_lib")
```
于是用的时候:
```cmake
# 假设你的 target 名为 testbed
target_include_directories(testbed PUBLIC ${hello_inc_dir})
target_link_libraries(testbed PUBLIC ${hello_lib})
```
不用担心有其他的库也要调用 `target_include_directories()` 和 `target_link_libraries()`. 只要没写 `include_directories()` 和 `link_libraries()`， 就可以多次用。

#### Elegant way
比如 modern cmake 一再强调的，链接一个依赖项的时，只要链接了库， 就别麻烦用户去配置 include 路径了。
换言之， 你可以“费点力气”创建一个 IMPORTED 类型的 target（通常是库类型的 target），但后续用的时候就轻松了：
```cmake
add_library(hello STATIC IMPORTED)
set_target_properties(hello PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_SOURCE_DIR}/3rdparty/hello"
    INTERFACE_POSITION_INDEPENDENT_CODE "ON"
)
...

target_link_libraries(testbed hello) # 只需要链接哦，不用蛋疼的配置头文件目录了
```
完整工程在 02_creating_targets/create_imported_lib_example



## 5. Cross-platform building

### generator

当执行 `cmake --help` , 屏幕输出很多帮助信息；帮助信息的最后一段是关于 generator 的（不同系统上执行，略有差异)。

Windows 平台，我们主要关注 Visual Studio 相关的，以及交叉编译常用的 Ninja 的。对于 VS2019：
```
-G "Visual Studio 16 2019" -A x64     // 64位
-G "Visual Studio 16 2019" -A win32   // 32位
```

对于 vs2017：
```
-G "Visual Studio 15 2017 Win64"      // 64位
-G "Visual Studio 15 2017"            // 32位
```

对于交叉编译，假定已经安装了 ninja：
```
-G "Ninja"
```

### cmake toolchain file

toolchain 主要设定每个平台上各自特有的东西，包括：
- flags，例如开启 ARM NEON，开启 -ffast-math，软硬浮点切换等
- 编译器路径（全名）或名称（编译器 bin 目录已经放在 PATH 的前提下）

**在哪儿找 toolchain 文件？**

- Android NDK 的 toolchain：在 `$ANDROID_NDK/build/cmake/android.toolchain.cmake`
- arm-none-linux-gnueabi: 我写了一个，放在 https://github.com/zchrissirhcz/cmake_examples/blob/master/arm-none-eabi_example/arm-none-eabi-gcc.toolchain.cmake
- 其他平台的 toolchain：可以在 ncnn 里头找找：https://github.com/Tencent/ncnn/tree/master/toolchains

**传入 toolchain**

调用 cmake 时传入 toolchain: `-DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN`，例如 `android-arm64-build.sh`:
```cmake
#!/bin/bash

ANDROID_NDK=~/soft/android-ndk-r21b
TOOLCHAIN=$ANDROID_NDK/build/cmake/android.toolchain.cmake

BUILD_DIR=android-arm64
mkdir -p $BUILD_DIR
cd $BUILD_DIR

cmake -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
    -DANDROID_LD=lld \
    -DANDROID_ABI="arm64-v8a" \
    -DANDROID_PLATFORM=android-24 \
    -DCMAKE_BUILD_TYPE=Release \
    ../..

#ninja
#cmake --build . --verbose
cmake --build .

cd ..
```

### write `xxx.toolchain.cmake` manually for embedded platform
交叉编译时需要 xxx.toolchain.cmake .
Android NDK 自带了 android.toolchain.cmake .
其他平台建议先从 ncnn 找找， 能用是最好的， 不能用也可以试着改改： https://github.com/Tencent/ncnn/tree/master/toolchains


## 6. Debugging
按以往经验， 不能像 Python 用 pdb 那样断点调试 CMake（其实可以， 但要源码编译 CMake 真的劝退人啊）。

### upgrade CMake version

- Install new version of CMake.
- Update `cmake_minimum_required(VERSION 3.xx)` to the latest, e.g. `3.26`

优秀的开源库如 opencv，ncnn，提供了良好的 find_package 支持。

但还有一大票开源的 C/C++ 项目，它们虽然基于 cmake 构建，但是提供的 find_package 支持有限，于是 cmake 官方在 cmake 安装包里头，放了这些开源 C/C++ 项目的 find_package 的“补丁”。具体说，是在 `/home/zz/soft/cmake-3.19.8/share/cmake-3.19/Modules` 这样的目录，提供了`FindGLEW.cmake` 这样的文件。于是乎，`find_package(GLEW)` 得以使用。

典型例子是， ncnn 使用了 vulkan ，旧版 cmake 里不提供 find_package(VUlkan) 的支持导致失败，升级 cmake 就解决了。


(然而即便如此，我发现 cmake 自带的这些 findxxx.cmake 脚本，还是不完美，有时候莫名其妙的让人踩坑，例如 zlib 的 FindZLIB.cmake 始终不检查 zlib 的静态库。。。这方法只能解决一部分问题）


### print (`message`)
CMake 的调试基本上是 print 大法:

类似于 C 语言的 `printf` 语句，但使用上有点技巧：

1. message("some message") 这是普通的打印
2. message(STATUS "some message") 这也是普通的打印
3. message(FATAL_ERROR "some message") 这相当于 printf 然后 exit(1)

通常用 `message(FATAL_ERROR` 来替代“断点调试” 的想法。

即：
- 基本的打印：
```cmake
message(STATUS ">>> CMAKE_BUILD_TYPE is: ${CMAKE_BUILD_TYPE}")
# message(STATUS "..." ) 相当于 C/C++ 的 printf("...")
```

- 打印并终止 cmake 的执行：
```cmake
message(FATAL_ERROR ">>> CMAKE_BUILD_TYPE is: ${CMAKE_BUILD_TYPE}")
# message(FATAL_ERROR "..." ) 相当于 C/C++ 的 fprintf(stderr, "..."); abort();
```

基本的 `message()` 命令实在弱小， 比如：
- 想打印一串变量每个一行那就要 `foreach()` 包一下
- 又或者依赖 `if()` 的判断逻辑按条件打印， 为了复用不妨放在 `macro()` 或 `function()` 中

我目前整理了几个函数在 sleek.cmake 里:
```cmake
# download https://github.com/zchrissirhcz/sleek/blob/master/sleek.cmake
include(sleek.cmake)
include(sleek.cmake)
sleek_print_cxx_flags()
```


### Clean cache: `CMakeCache.txt`
删掉 CMakeCache.txt 然后重新 CMake， 往往能解决（新手）的大部分莫名奇妙的“不生效”问题。

在执行 cmake 的目录下，有一个名为 `CMakeCache.txt` 的文件。它是 cmake 缓存变量的描述文件。所谓缓存变量（cache variable），指的是有预定义值的变量，如果不提供新的值来覆盖就用预定义值，如果要覆盖则通过 `cmake -D<var>=<value>` 的方式传入。

当 find_package 这样的语句失败（例如找了错误的 opencv），很多人会说 “删掉 build 目录重新来”，这其实过于暴力了，只要删除 `build` 目录下的 CMakeCache.txt 即可。甚至不用删，覆盖里面的值也是 OK 的。（又或者，打开这个文件编辑里面的值，或者用 cmake-gui 这样的工具手动修改。）

### `compile_commands.json`

### `link.txt`

### find clues in CMake GUI
CMake-GUI 是一个图形界面软件，里面可搜索 Cache Entry，或切换查看缓存变量。
如果是 Linux/MacOSX 还可以用 ccmake, 也就是 cmake 的命令行版本的“文字GUI界面”。



## 7. Modern CMake


### understand modern cmake
modern cmake 是针对每个 target 进行配置， 而 classical cmake 则是完全全局设置一把梭。

使用 modern cmake， 意味着尽可能的不用如下几条命令：
- `include_directories()`
- `link_directories()`
- `link_libraries()`
- `add_definitions()`

也意味着尽可能的不去设置如下几个全局变量的值：
- `CMAKE_DEBUG_POSTFIX`
- `CMAKE_POSITION_INDEPENDENT_CODE`
作为替代的命令， 见如下 0x1~0x7 小节。

值得说的是， 使用 modern cmake 时仍然需要 `option`, `set(CMAKE_BUILD_TYPE Release)` 等全局设置。

### create target

```cmake
add_executable(testbed xxx.cpp) # 可执行目标； 很常用
add_library(some_lib xxx.cpp) # 默认静态库；不建议这么写
add_library(some_lib STATIC xxx.cpp) # 静态库目标；很常用；
add_library(some_lib SHARED xxx.cpp) # 动态库目标； 还需要考虑C/C++ API的符号导出；暂时不怎么用
add_library(some_lib INTERFACE xxx.hpp) # header-only 的库
```
还有 定制目标（暂时不会）

### header file searching
绑定到 Target:
```cmake
target_link_libraries(some_target PUBLIC some_include_dir)
# PUBLIC可以视情况换成PRIVATE/INTERFACE。
```

全局地：
```cmake
include_directories()
```

### specify required dependencies
绑定到 Target:
```cmake
target_link_libraries(some_target PUBLIC some_lib)
# PUBLIC可以视情况换成PRIVATE/INTERFACE。
# 有一个 target_link_directories(), 尽可能不要用它
```

全局地（不建议用）：
```cmake
link_directories(some_directories)
link_libraries(some_target some_libraries)
```

`some_lib` 用全局路径， 或者前面创建的（静态或动态库）target， 或者是 find_package / find_library 找到的包， 或者是导入库（imported）。

不要用 `link_directories()` + 不带路径只有文件名的库的形式； 一方面污染全局， 另一方面如果两个路径下有同名的库，选择哪个库（尤其是跨平台编译时）是不确定的。

### specify header file
```cmake
set_target_properties(foo PROPERTIES
    PUBLIC_HEADER
        foo.h
)
```
好处：使用 `install(TARGETS foo)` 时把库文件和公共头文件都拷贝过去了。

### setting C++ standard
绑定到 Target：
```cmake
set_target_properties(joinMap
    PROPERTIES
    CXX_STANDARD 17
)
```

或另种方式绑定到 Target:
```cmake
target_compile_features(${TARGET_NAME} PRIVATE cxx_std_17)
```

全局地：
```cmake
set(CMAKE_CXX_STANDARD 11) # 或14, 17
```

### define macros
```cmake
target_compile_definitions(testbed PRIVATE P2P_API) #定义 P2P_API 为 1
target_compile_definitions(testbed PRIVATE -DP2P_API) # 定义 P2P_API 为 1
target_compile_definitions(testbed PRIVATE -DP2P_API=233) # 定义 P2P_API 为 233
```
注：这里说的宏，是CMake生成的Makefile或.sln 里，传给C/C++编译器看的宏，不是 CMake 里的宏。(CMake 里的宏是类似于 CMake 函数的一种用法)。

可通过 `set(CMAKE_EXPORT_COMPILE_COMMANDS ON)` 后，生成 `compile_commands.json` 数据库文件查看具体的宏（非 MSVC 平台）。

全局地：
```cmake
add_definitions(P2P_API)
add_definitions(-DP2P_API)
add_definitions(-DP2P_API=1)
```

### specify postfix (e.g. debug libraries with `_d`)
绑定到 Target:
```cmake
set_target_properties(ncnn PROPERTIES DEBUG_POSTFIX "d") # 指定ncnn debug库的后缀为d

set_target_properties(toy_imgproc PROPERTIES DEBUG_POSTFIX "_d") # 指定toy_imgproc debug库的后缀为_d

# 注意这里的target也可以是可执行target
```

全局地:
```cmake
set(CMAKE_DEBUG_POSTFIX d)
```

或在调用 CMake 时传入(例如google的crc32c库、libjpeg-turbo库，作者打死都不肯加postfix的），自己动手丰衣足食):
```bash
-DCMAKE_DEBUG_POSTFIX=d
```

### customized compile options
```cmake
target_compile_options()
```

全局的：`add_compile_options()`

用法举例：
```cmake
# https://docs.microsoft.com/en-us/cpp/build/cmake-presets-vs?view=msvc-170#enable-addresssanitizer-for-windows-and-linux
option(ASAN_ENABLED "Build this target with AddressSanitizer" ON)

if(ASAN_ENABLED)
  if(MSVC)
    target_compile_options(<target> PUBLIC /fsanitize=address)
  else()
    target_compile_options(<target> PUBLIC -fsanitize=address <additional-options>)
    target_link_options(<target> PUBLIC -fsanitize=address)
  endif()
endif()
```