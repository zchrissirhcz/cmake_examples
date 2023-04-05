# cmake tutorial

[TOC]

## 0. 目的
随便写点 cmake tutorial， 不求全面， 只是稍作入门引导。

有些可能写的不对， 可以开 issue / PR 反馈。

## 1. CMake 语法
### 1.1 文件名
- CMakeLists.txt
  - 这是构建描述的入口文件，必须有的
- *.cmake, 可选的
  - 形如 OpenCVConfig.cmake 的 <PkgName>Config.cmake 或 <pkgname>-config.cmake
  - 形如 FindZLIB.cmake 的 FindXXX.cmake
  - 形如 sleek.cmake 的自己瞎搞的名字前缀、但以 .cmake 为后缀的文件

### 1.2 起手式 - 30秒入门的语法
背下来这经典的起手式 CMakeLists.txt
```cmake
cmake_minimum_required(VERSION 3.20)
project(x)
add_executable(testbed testbed.cpp)
```
并创建配套的 testbed.cpp:
```c++
#include <stdio.h>
int main()
{
    printf("hello, cmake\n");
    return 0;
}
```

运行：
```bash
mkdir build
cd build
cmake ..
make
```
或:
```bash
cmake -S . -B build
```
其中 `-S .` 表示 source 路径为当前路径， source 路径指的是 CMakeLists.txt 所在目录；`-B` 表示 build 产出的目录。`cmake ..` 则是省略 -S 和 -B, 并且参数 `..` 表示上一级目录有 CMakeLists.txt.

### 1.3 变量

**官方文档**
https://cmake.org/cmake/help/v3.20/manual/cmake-variables.7.html


**普通变量**
```cmake
set(HELLO "hello world")  # 定义
message(STATUS "HELLO's value: ${HELLO}") # 打印
```

**缓存变量(cache variable)**
官方文档：https://cmake.org/cmake/help/v3.20/variable/CACHE.html

cmake cache variable 指的是有默认值（预设值）的变量，可以提供新的值来覆盖。
```cmake
set(OpenCV_DIR "/usr/lib/x86_64-linux-gnu/cmake/opencv4" CACHE PATH "这里写对于此缓存变量的注释")
message(STATUS "OpenCV_DIR: ${OpenCV_DIR}")
```

**环境变量**
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

## 2. CMake 代码风格

### 2.1 语法高亮
在不熟悉 CMake 时请确保您的编辑器/IDE中对 CMakeLists.txt 和 *.cmake 文件有高亮显示。

我用 VSCode 最多， twxs 的 CMake 插件就够了， 微软的 CMake Tools（原作者是 vector-of-bool）不太需要。

### 2.2 大小写
>原则1： 关键字(如set/if)，大写、小写、混合大小写，都不会报错；此时应主动改为小写
>原则2： 内置变量(如CMAKE_SOURCE_DIR)只能用大写
>原则3:  您自己定义的变量或函数名儿，想咋整就咋整

举例：

```cmake
set(var "123")   # 良好，set 是小写
SET(var "123")   # 糟糕，SET 不推荐大写
SeT(var "123")   # 很糟，在瞎搞
```

列出常见的关键字：
- set
- list
- if, else, elseif, endif
- foreach, endforeach
- function, endfunction
- macro, endmacro

列出常见的 CMake 内置变量：
- CMAKE_SOURCE_DIR
- CMAKE_BINARY_DIR
- CMAKE_CURRENT_FILE
- PROJECT_SOURCE_DIR
- CMAKE_C_FLAGS
- CMAKE_CXX_FLAGS
- CMAKE_BUILD_TYPE
- CMAKE_LINKER_FLAGS

### 2.3 缩进
>原则1: 推荐空格缩进， 而不是 tab 缩进
最好是给当前 IDE/编辑器安装 EditorConfig 插件， 统一配置起来

>原则2: 缩进空格数量要统一
所有文件都用2空格，或都用4空格。不推荐3空格。

>原则3: 命令和小括号之间是否有空格要统一，推荐命令后紧跟小括号
举例：
```cmake
set(my_srcs "1.cpp") # good
set (my_srcs "1.cpp") # bad
```

举例2:
```cmake
# good
if(CMAKE_SYSTEM_NAME MATCHES "Windows")
  message(STATUS "windows")
endif()

# bad, if 后不要空格
if (CMAKE_SYSTEM_NAME MATCHES "Windows")
  message(STATUS "windows")
endif()
```

### 2.4 古典 CMake 和现代 CMake
cmake 是一个有着多年历史的软件； 类似于 C++ 分为 classical c++ 和 modern c++， cmake 也区分 classifical cmake 和 modern cmake。
- classical cmake：古典 cmake，各种设置往往是全局的，不能说不work，只能说潜在的坑比较多，不够灵活
- modern cmake：类似于 object orientated 的想法，尽量减少全局设定，尽量按每个 target 设定， target 属性有 PRIVATE/PUBLIC/INTERFACE 这样的修饰关键字

通常来说，能用最新 cmake 就用最新版的。通常是兼容老版本的。

这里先不具体展开， 大概有个印象（因为能展开的细节太多了）

## 3. 赶紧跑个 HelloWorld 吧
>“代码和人，总要有一个能跑”

## 4. 设置编译选项

### 全局的
咱也不是完全反对全局设置。

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

开启 AddressSanitizer（以下一大坨看似头疼，其实能适配99%的 CMAKE_BUILD_TYPE，通常无脑copy使用）
```cmake
option(USE_ASAN "Use Address Sanitizer?" ON)
#--------------------------------------------------
# globally setting
#--------------------------------------------------
# https://stackoverflow.com/a/65019152/2999096
if(USE_ASAN)
  if(MSVC)
    message(WARNING "AddressSanitizer for MSVC must be enabled manually in project's property page.")
  else()
    message(STATUS ">>> USE_ASAN: YES")
    message(STATUS ">>> CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
    if(CMAKE_BUILD_TYPE MATCHES "Debug")
      # On debug mode
      set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_LINKER_FLAGS_DEBUG "${CMAKE_LINKER_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")
    elseif(CMAKE_BUILD_TYPE MATCHES "Release")
      # Note: `-g` is explicitly required here, even if NDK android.toolchain.cmake's `-g` exists.
      set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_LINKER_FLAGS_RELEASE "${CMAKE_LINKER_FLAGS_RELEASE} -g -fno-omit-frame-pointer -fsanitize=address")
    elseif(CMAKE_BUILD_TYPE MATCHES "RelWithDebInfo")
      set(CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_LINKER_FLAGS_RELWITHDEBINFO} -g -fno-omit-frame-pointer -fsanitize=address")
    elseif(CMAKE_BUILD_TYPE MATCHES "MinSizeRel")
      set(CMAKE_C_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_LINKER_FLAGS_MINSIZEREL "${CMAKE_LINKER_FLAGS_MINSIZEREL} -g -fno-omit-frame-pointer -fsanitize=address")
    elseif(CMAKE_BUILD_TYPE EQUAL "None" OR NOT CMAKE_BUILD_TYPE)
      set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -fno-omit-frame-pointer -fsanitize=address")
      set(CMAKE_LINKER_FLAGS "${CMAKE_LINKER_FLAGS} -g -fno-omit-frame-pointer -fsanitize=address")
    else()
      message(FATAL_ERROR "unsupported CMAKE_BUILD_TYPE for asan setup: ${CMAKE_BUILD_TYPE}")
    endif()
  endif()
else()
  message(STATUS ">>> USE_ASAN: NO")
endif()
```

开启/关闭调试符号信息：
可以手动改 ndk 的 toolchain.cmake 中的 "-g"，也可以用类似上面 Address Sanitizer 的方式设置；或者用我封装好的 cmake 函数：
```cmake
# download https://github.com/zchrissirhcz/sleek/blob/master/sleek.cmake
include(sleek.cmake)
sleek_add_debug_symbol()
```
弄懂这个 sleek_add_debug_symbol() 需要会写点 cmake 的 function 和 macro 。

### 你没有讲怎么加 -O2
我很少自己加 -O2. 如果是 CMAKE_BUILD_TYPE 为 Release， 在没传 toolchain 文件情况下它就是 O2 的。
如果传了 toolchains， 那么 toolchains 本身可以设置 Release 对应的 flags，比如 -O2， -O3 都可以。

## 5. 处理依赖库

(TODO)

### 5.1 浅入浅出 find_package() 


#### XXX_DIR 是啥， 怎么设？
你可能想问的是，能否讲讲下面这两句：
```cmake
set(OpenCV_DIR "xxx")
find_package(OpenCV REQUIRED)
```

确实， 这两句难坏了好多新手， 是让人产生 “cmake忒难用了！”的重要原因， 因为 “博客/教程里写的简单， 但是我执行后一直报错， 一下午也没配好！”， 云云。

很久之前我看了 `find_pacakge()` 官方文档，写了笔记： [深入理解CMake(3):find_package()的使用](https://www.jianshu.com/p/39fc5e548310)

简单说，`OpenCV_DIR` 要设定为 `OpenCVConfig.cmake` 这个文件所在的目录， 而 `ncnn_DIR` 则要设置为 `ncnnConfig.cmake` 所在的目录。

然而你不要去记忆 `OpenCV_DIR` 的具体取值，因为它在 Windows 上取值是 “安装 OpenCV 的根目录”，而在 Linux/MacOSX/Android NDK 上则是 `lib/cmake/opencv4` 这样的目录（为啥不统一我也不清楚；反正后者的写法确实有规律，如 ncnn， googletest 等 CMake 支持比较好的项目中都是那样放的）。

那为啥我设了 `OpenCV_DIR` 为包含 `OpenCVConfig.cmake` 的目录之后， CMake 还是失败？ 几种可能：
- 前一次执行 cmake 失败了，读取了错误的 OpenCV_DIR 取值， 或者你没设置这个变量， 但是你的系统环境变量 PATH 干扰了 CMake
- 你的编译器版本和 OpenCV_DIR 指向目录的包对应的编译器版本， 不匹配
  - 如： VS 的版本
  - 再如： 交叉编译到 arm linux， 但是却找到了 x86-64 linux 的 OpenCV， elf 文件格式都不一样，肯定链接不上

#### 例子: protobuf
- [深入理解CMake(4)：find_package寻找系统Protobuf（apt）的过程分析](https://www.jianshu.com/p/2946b0e5c45b)

- [深入理解CMake(5)：find_package寻找手动编译安装的Protobuf过程分析](https://www.jianshu.com/p/5dc0b1bc5b62)

- [深入理解CMake(6):多个Protobuf版本时让find_package正确选择](https://www.jianshu.com/p/ae5c56845896)

#### 例子: OpenCV

**OpenCV_DIR**

首先找到 OpenCVConfig.cmake 所在路径

对于自行编译安装到 `/home/zz/soft/opencv-4.5.2` 的，这样找：
```bash
find /home/zz/soft/opencv-4.5.2 -name 'OpenCVConfig.cmake' | xargs realpath | xargs dirname
```

对于 apt 安装的，则是在：
```bash
sudo apt install libopencv-dev
dpkg -L libopencv-dev | grep 'OpenCVConfig.cmake' # 结果为 /usr/lib/x86_64-linux-gnu/cmake/opencv4/
```

然后设定 `OpenCV_DIR` 这一缓存变量：
```cmake
cmake_minimum_required(VERSION 3.15)
project(testbed)
set(OpenCV_DIR "" CACHE PATH "/usr/lib/x86_64-linux-gnu/cmake/opencv4")
```

#### 例子: ncnn

ncnn 各个平台的预编译包（或自行编译安装的目录下），提供了 ncnnConfig.cmake 。

对于使用 GPU 的情况，ncnnConfig.cmake 已经正确处理了依赖库的顺序。

```bash
set(ncnn_DIR "..." CACHE PATH "Directory that contains ncnnConfig.cmake")
find_package(ncnn REQUIRED)
target_link_libraries(testbed ncnn)
```

#### 例子：ffmpeg

由于 ffmpeg 官方没提供 cmake 构建支持。我手写了 ffmpeg 的 find_package 支持。


### 5.2 写 xxx.cmake 或 FindXXX.cmake
有头文件，有库文件，但是没 xxx.cmake 或 FindXXX.cmake

#### 暴力一点的搞法
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

#### 怎样优雅、不暴力的配置？
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

#### 再优雅点？
你前面配置的虽然 work， 但是是在当前工程里配置的。我换个工程，或者要共享给别人，咋用？

嗯，就把 IMPORTED 那一段copy出来，放在 hello.cmake 中吧！不过，你可以做更多补充：
- debug 库和 release 库同时存在，咋弄？关键字： optimize
- 如果 hello 这个库本身还依赖别的库呢？ 例如 openmp？

#### 再再优雅点？
比如说吧，给我 hello 库的人， 更新库了。我咋区分新旧两个版本的 hello 库呢？注意是 cmake 方式区分。

好吧我摊牌了， 还没有特别好用的 C++ 包管理器， 但是有一些可以凑合用的：
- vcpkg： 开源公共库支持的比较多。 不过由于官方没合并我的 PR 还拒不认错，我不用它
- conan.io: 基于 JFrog ARTIFACTORY 的，应该是不错的，我没用过- 不过公司有类似的方案实现的包管理库，用起来很舒服就是了


#### 我就想要 FindXXX.cmake 的例子，快给我！
我写过 FindZLIB.cmake: https://github.com/zchrissirhcz/sleek/blob/master/FindZLIB.cmake

cmake 安装包里自带了 FindZLIB.cmake, 但是它有bug， 只找动态库不找静态库；而 cmake 官方说每个 package 的 FindXXX.cmake 由 contributor 维护； 可是这些 contributor 也不来 github 毫不活跃的样子，那就自己瞎改改用吧！


## 6. 跨平台（交叉编译）

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

### cmake toolchain 文件

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

### 嵌入式平台: 自己动手写 xxx.toolchain.cmake
交叉编译时需要 xxx.toolchain.cmake .
Android NDK 自带了 android.toolchain.cmake .
其他平台建议先从 ncnn 找找， 能用是最好的， 不能用也可以试着改改： https://github.com/Tencent/ncnn/tree/master/toolchains


## 7. 调试 CMake
按以往经验， 不能像 Python 用 pdb 那样断点调试 CMake（其实可以， 但要源码编译 CMake 真的劝退人啊）。

### 升级 cmake 法

优秀的开源库如 opencv，ncnn，提供了良好的 find_package 支持。

但还有一大票开源的 C/C++ 项目，它们虽然基于 cmake 构建，但是提供的 find_package 支持有限，于是 cmake 官方在 cmake 安装包里头，放了这些开源 C/C++ 项目的 find_package 的“补丁”。具体说，是在 `/home/zz/soft/cmake-3.19.8/share/cmake-3.19/Modules` 这样的目录，提供了`FindGLEW.cmake` 这样的文件。于是乎，`find_package(GLEW)` 得以使用。

典型例子是， ncnn 使用了 vulkan ，旧版 cmake 里不提供 find_package(VUlkan) 的支持导致失败，升级 cmake 就解决了。


(然而即便如此，我发现 cmake 自带的这些 findxxx.cmake 脚本，还是不完美，有时候莫名其妙的让人踩坑，例如 zlib 的 FindZLIB.cmake 始终不检查 zlib 的静态库。。。这方法只能解决一部分问题）


### print 大法(message打印)
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

### 看 log
CMake 执行后会生成 `CMakeCache.txt` 文件。
如果 CMake 执行失败， 还会提示说 “报错了！详细信息在 xxx 文件”。

### 查看 CMakeCache 的方法

在执行 cmake 的目录下，有一个名为 `CMakeCache.txt` 的文件。它是 cmake 缓存变量的描述文件。所谓缓存变量（cache variable），指的是有预定义值的变量，如果不提供新的值来覆盖就用预定义值，如果要覆盖则通过 `cmake -D<var>=<value>` 的方式传入。

当 find_package 这样的语句失败（例如找了错误的 opencv），很多人会说 “删掉 build 目录重新来”，这其实过于暴力了，只要删除 `build` 目录下的 CMakeCache.txt 即可。甚至不用删，覆盖里面的值也是 OK 的。（又或者，打开这个文件编辑里面的值，或者用 cmake-gui 这样的工具手动修改。）

### 清理缓存
删掉 CMakeCache.txt 然后重新 CMake， 往往能解决（新手）的大部分莫名奇妙的“不生效”问题。

### CMake GUI 里头找线索
CMake-GUI 是一个图形界面软件，里面可搜索 Cache Entry，或切换查看缓存变量。
如果是 Linux/MacOSX 还可以用 ccmake, 也就是 cmake 的命令行版本的“文字GUI界面”。

### 查看官方手册

仍然是在 find_package 的过程中遇到的比较多。find_package 依赖于具体的 xxx-config.cmake 或 findxxx.cmake 脚本，里面很可能调用了 find_path / find_library / find_file 等 cmake 自带的函数，但是传入的参数不太一样，需要查阅手册，结合前面提到的 `message(FATAL_ERROR` 方法来排查。

## 8. 正经的现代 CMake
(TODO)
`#include "现代cmake.md"`

## 9. 其他杂项

### 9.1 执行命令
绑定到具体目标：
```cmake
add_custom_command(TARGET testbed
  POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/data ${CMAKE_BINARY_DIR}/data
)
```

全局地：
```cmake
execute_process(
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/data ${CMAKE_BINARY_DIR}/data
)
```

命令包括：
- copy_directory
- copy_if_different