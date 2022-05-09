# cmake tutorial

[TOC]

## 0. 目的
随便写点 cmake tutorial， 不求全面， 只是稍作入门引导。

有些可能写的不对， 可以开 issue / PR 反馈。

## 1. CMake 语法：30秒入门
### 1.1 文件名
- CMakeLists.txt
  - 这是构建描述的入口文件，必须有的
- *.cmake, 可选的
  - 形如 OpenCVConfig.cmake 的 <PkgName>Config.cmake 或 <pkgname>-config.cmake
  - 形如 FindZLIB.cmake 的 FindXXX.cmake
  - 形如 sleek.cmake 的自己瞎搞的名字前缀、但以 .cmake 为后缀的文件

### 1.2 语法
- 背下来这经典的起手式 CMakeLists.txt
```cmake
cmake_minimum_required(VERSION 3.20)
project(x)
add_executable(testbed testbed.cpp)
```

- 其他语法：就当不存在吧，用到再学

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

### 6.1 使用 CMAKE_TOOLCHAIN_FILE: Android NDK 例子

### 6.2 嵌入式平台: 自己动手写 xxx.toolchain.cmake
交叉编译时需要 xxx.toolchain.cmake .
Android NDK 自带了 android.toolchain.cmake .
其他平台建议先从 ncnn 找找， 能用是最好的， 不能用也可以试着改改： https://github.com/Tencent/ncnn/tree/master/toolchains


## 7. 调试 CMake
按以往经验， 不能像 Python 用 pdb 那样断点调试 CMake（其实可以， 但要源码编译 CMake 真的劝退人啊）。

### print 大法
CMake 的调试基本上是 print 大法:

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

然而这基本的 `message()` 命令实在弱小， 比如：
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

### CMake GUI 里头找线索
CMake-GUI 是一个图形界面软件，里面可搜索 Cache Entry，或切换查看缓存变量。
如果是 Linux/MacOSX 还可以用 ccmake, 也就是 cmake 的命令行版本的“文字GUI界面”。

### 清理缓存
删掉 CMakeCache.txt 然后重新 CMake， 往往能解决（新手）的大部分莫名奇妙的“不生效”问题。

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