# vscode cmake example

[TOC]

## 0x0 目的
看完本文和本样板工程， 应该能够使用 VSCode 进行 C++ 代码的（断点）调试。

## 0x1 旧版配置
2018年和师弟在实验室一起调程序， 当时整理了“怎样用 VSCode 调试基于 cmake 构建的 C/C++ 工程”的博客：

https://www.cnblogs.com/zjutzz/p/9389106.html

这里贴出最近顺手的配置， 相比于原文有大幅升级； 可以直接用当前工程来练习， 或拷贝 `.vscode` 目录到你的工程自行魔改。

## 0x2 VSCode 插件的问题
如果是新安装的 VSCode， 打开 C++ 文件后会提示安装插件， 很容易就“中圈套”安装了 cpptools 这一“微软官方C++插件”。这没错， 小白用户基本够用。

但是也可以有别的选择， 例如我目前是 clangd + codelldb， 正常用起来需要更多一点的配置。

注意 cpptools 和 clangd 两个插件是冲突的， 只能开启其中一个， 切换后注意重启当前 VSCode 实例。

## 0x3 编译器的问题： GCC（G++）， Clang（Clang++）？

我主要用 Ubuntu， GCC 和 Clang 都可以配置起来调试 C++ 代码的。

如果是 macOSX 系统， gcc 其实是 clang 的马甲， 而所谓 clang 其实是 AppleClang， 基本上和 Clang 一样用即可。

暂时没尝试配置 Visual Studio 内置的编译器到 VSCode 中， 但应该不难； 我主要用 Linux。

## 0x4 调试器的问题： gdb， lldb ?

对于 Linux 平台来说， gdb 和 lldb 基本兼容可以互换使用， 可能最主要区别是好多 gdb / lldb 命令不太一样， 其他应该都兼容（或简单的认为“一样”即可）。

当然最基本的也最容易忘的是： 安装调试器！ 不然后面配置半天调试不了， 太尴尬了

```bash
# GCC 的话， 我只用 apt 默认装的 GCC 版本， 因此安装 gdb 时版本也用默认的
sudo apt install gdb

# Clang 的话， 我尝试过安装 apt 默认的版本， 但不够新
# sudo apt install lldb
# 当前则是通过apt安装最新版： https://apt.llvm.org/ , 配置源后即可安装
sudo apt install clang-14 lldb-14
```

## 0x5 .vscode/launch.json 的配置

可配置项比较多， VSCode 官方文档也很详细， 这里只补充说下踩坑后的经验：

1. "configurations" 中 "type" 字段有讲究， 是根据当前启用的 C++ 插件确定的， 若不能调试很可能是这个字段写错了：
- cpptools 插件对应 "cppdbg"
- clangd 插件对应 "lldb" （若此时未安装lldb，似乎也可调试？待证实）

2. 基于 lldb 的调试， 需要安装 lldb-mi 并配置， ubuntu 上的 apt 不提供 lldb-mi 的下载， 只能手动编译；门槛略高导致最近才走通此方案， 下面贴出详细步骤：

### 1） 基于 lldb 调试的讨论帖
https://github.com/microsoft/vscode-cpptools/issues/5415

虽然有帖子有步骤， 但没法完全照搬 -- 我想用 Clang 14， 帖子里是 Clang 10。

### 2） 安装 lldb-mi 需要的依赖项
```bash
# 网络环境不佳情况下， 让 apt 走 proxy 加速， 不然装不上依赖
# https://apt.llvm.org/ 这个对应的 repo， 目测没有国内镜像可用
export https_proxy="http://127.0.0.1:36219"

# 安装依赖； 若失败一次， 请追加 --fix-missing 再次尝试
sudo apt install liblldb-14-dev llvm-14-dev
```

### 3） 编译安装 lldb-mi
```bash
# 找个合适地方， 拉取代码
cd ~/work/github
git clone https://github.com/lldb-tools/lldb-mi.git
cd lldb-mi

# 尝试编译
mkdir build && cd build
cmake ..
cmake --build . # 也就是 make
```
正常情况下就编译好了， 但是存在两个问题：
- Q1. 编译报错了！
```
fatal error: 'lldb/API/SBError.h' file not found
```
- Q2. 没指定安装位置（小问题）

对于问题Q1， 是说头文件没找到， 但其实 lldb-14-dev 里肯定安装了的， 验证一下：
```bash
# sudo apt install silversearcher-ag  # 确保安装了 ag 命令
dpkg -L liblldb-14-dev | ag 'lldb/API/SBError.h'
```
确实可以找到结果：
> /usr/lib/llvm-14/include/lldb/API/SBError.h

那为啥编译 lldb-mi 还是找不到呢？ 看了它的 CMakeLists.txt， 会找 llvm 的 package：
```cmake
cmake_minimum_required(VERSION 3.4.3)

if(POLICY CMP0077)
  cmake_policy(SET CMP0077 NEW)
endif()

project(lldb-mi)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

if (USE_LLDB_FRAMEWORK AND !APPLE)
  message(FATAL_ERROR "USE_LLDB_FRAMEWORK is only avaliable on Darwin")
endif()

find_package(LLVM REQUIRED CONFIG)  #!! 这里， 最关键

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

list(APPEND CMAKE_MODULE_PATH ${LLVM_DIR})
include(HandleLLVMStdlib)
include(HandleLLVMOptions)

include_directories(${LLVM_INCLUDE_DIRS})
if(LLVM_BUILD_MAIN_SRC_DIR)
  include_directories(${LLVM_BUILD_MAIN_SRC_DIR}/../lldb/include) #!! 这里，头文件搜索目录
  include_directories(${LLVM_BUILD_BINARY_DIR}/tools/lldb/include) #!! 还有这里
endif()

...
```

因此把最关键的 `find_package(LLVM REQUIRED CONFIG)` 解决一下， 对 `find_package()` 的高度熟悉因此直接找对应的 config cmake 文件：

```bash
# 保险起见， 应当两次搜索过滤
dpkg -L llvm-14-dev | ag 'cmake' | ag 'config'
```

>(base) zz@home% dpkg -L llvm-14-dev | ag 'cmake' | ag 'config'
>/usr/lib/llvm-14/lib/cmake/llvm/LLVM-Config.cmake
>/usr/lib/llvm-14/lib/cmake/llvm/LLVMConfig.cmake
>/usr/lib/llvm-14/lib/cmake/llvm/LLVMConfigExtensions.cmake
>/usr/lib/llvm-14/lib/cmake/llvm/LLVMConfigVersion.cmake


```bash
# 也可以上帝视角直接一次搜索：
dpkg -L llvm-14-dev | ag 'LLMV-Config.cmake'
```
>/usr/lib/llvm-14/lib/cmake/llvm/LLVM-Config.cmake

**总之得到了 `LLVM_DIR` 的正确路径， 也就是 LLVM-Config.cmake 所在目录**, 传给 cmake， 并额外指定 lldb-mi 的安装路径， 完成编译安装：

```bash
cmake .. -DLLVM_DIR=/usr/lib/llvm-14/lib/cmake/llvm  -DCMAKE_INSTALL_PREFIX=~/soft/lldb-mi
cmake --build .
cmake --install .
```

### 4)  在 .vscode/launch.json 中配置 lldb-mi
```json
{
    "name": "debug-lldb",

    ...

    "MIMode": "lldb", //!!

    ...

    "miDebuggerPath": "/home/zz/soft/lldb-mi/bin/lldb-mi", //!!
}
```

### 5)  生成 compile_commands.json 文件
也就是编译数据库文件， 通过开启 `CMAKE_EXPORT_COMPILE_COMMANDS` 来实现。方式有很多， can be one of:
- CMakeLists.txt 开头， project 之后开启
- 调用 cmake 时手动传入
- 环境变量

## 0x6 clangd 插件设置
clangd 的配置是可选的。若修改后未立即生效，需要关掉重开 VSCode 实例。

### 指定 compile_commands.json 所在路径
若不是在 build 目录， 则需要手动指定， 用于 clangd 项目正确的函数跳转:

Clangd: Arguments
```
-compile-commands-dir=build/linux-x64
```

### 定义宏
例如在 PC 上看 ARM 相关的代码, 默认是绿色（未高亮）；若定义了 `__ARM_NEON` 宏则可以高亮显示：

Clangd: Arguments
```
-D__ARM_NEON=1
```

## 0x7 调试单个文件 / 调试无源码的可执行文件
见 task.json 中 debug-no-source 的配置。

作为验证， 可使用 a.c 内容进行编译调试：
```bash
gcc a.c
```

## 0x8 远程调试
以 Android 控制台程序的调试为例， 底层使用 lldb-server 和 lldb， 安装 CodeLLDB 插件后稍作配置， 就可以在 VSCode 里调试。

1. 拷贝 lldb-server 到设备
```bash
# 这里用的 ndk-r21e 版本， 其他版本没试过
cd /home/zz/soft/android-ndk-r21e
adb push ./toolchains/llvm/prebuilt/linux-x86_64/lib64/clang/9.0.9/lib/linux/aarch64/lldb-server /data/local/tmp/
```

2. 配置 task.json 和 launch.json
设备编号和端口可自行修改。
```
List of devices attached
4af156d2        device

```
我使用 4af156d2 和 10086.

3. 开启监听
```bash
cat remote-debug-listen.sh
```

```bash
adb shell
cd /data/local/tmp
./lldb-server platform --listen *:10086 --server
```

4. Debug 模式编译, 带调试符号信息 -g
例如手动改了本地 NDK 目录下 build/cmake/android.toolchains.cmake ， 去掉了里面的 `-g`， 会导致编译出的二进制文件里缺失符号信息， 则无法断点调试。
解决办法：
- 把 ndk 恢复原样
- 或， 手动把 -g 在当前工程的 CMakeLists.txt 中添加回来， 参考 [04_global_configurations/debug_symbol_example](../04_global_configurations/debug_symbol_example) .

5. 在 VSCode 里断点调试
和在 PC 上一样.

## 0x9 Windows 上配置 Visual Studio 的 cl.exe 编译器进行调试
![](snapshots/vscode_debug_with_vs2022.png)

和之前 Linux/Android NDK 工程的调试类似，cl.exe 作为编译器时也能够配置为：
- 调试单个.c/.cpp文件
- 调试基于 CMake 的一整个工程

网上绝大部分博客和视频教程，是在 Windows 下配置 MinGW/TDM-GCC 编译器， 我想说这有点本末倒置了， Windows 下用 cl.exe 的原因是各种第三方库（如预编译的 OpenCV）是 MSVC 编译的， MinGW/TDM-GCC 编译的三方库不多限制了发展上限。

主要关注点：
- 0x9 这里的配置， 用的插件是 cpptools， 也就是微软的那个 C++ 插件
- `type` 需要指定为 `cppvsdbg`, `cppdbg` 则无效
- 需要写 `build/vs2022-x64.cmd` 用来调 cmake 执行编译

[Configure VS Code for Microsoft C++](https://code.visualstudio.com/docs/cpp/config-msvc?msclkid=112f19dbc70211ecb65a7a4f8706a3d7)

## 0x10 进阶

0x1~0x6看似繁琐的步骤仅仅是调试 C/C++ 的入门门槛， 绕开了"直接使用 gdb / lldb 命令行调试"。进阶内容则比较宽泛：
- 在 VSCode 调试时的调试器窗口， 练习使用 gdb / lldb 调试命令
- 多线程调试， 例如死锁
- 传参特别多的情况下， 例如 cv::Mat 转为 cv::InputArray, 想办法跳过
- 改掉 compile_commands.json 默认搜索目录的问题
- 学习使用 python 来增强 gdb / lldb
- codelldb 对接 rr 后端：https://github.com/vadimcn/vscode-lldb/wiki/Reverse-debugging-with-RR
- ...

<hr>

## 0x9 可能的报错和解决方法

（一些可能含有错误、仅供参考的内容， 暂时记录在这里）

如果要用 clang 作为编译器，搭配的调试器是 lldb。要在 VSCode 里用 lldb 调试，需要能找到 lldb-mi 这一可执行程序，或手动指定其路径。

在 ubuntu 20.04 上，由于官方没有把 lldb-mi 打包到进 apt（一说是忘记了），需要自行编译 lldb-mi （只需要 10 秒钟）：

```bash
sudo apt install liblldb-10-dev

cd ~/work
git clone https://github.com/lldb-tools/lldb-mi.git
cd lldb-mi
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=~/soft/lldb-mi
cmake --build .
cmake --install .

# 覆盖系统的 lldb-mi 软链接；可选
sudo ln -sf /home/zz/soft/lldb-mi/bin/lldb-mi /usr/bin/lldb-mi
```

launch.json 中指定:
```json
"miDebuggerPath": "/home/zz/soft/lldb-mi/bin/lldb-mi",
```

### 报错1: registered more than once!
断点调试遇到报错：
```
: CommandLine Error: Option 'help-list' registered more than once!
LLVM ERROR: inconsistency in registered CommandLine options
[1] + Aborted (core dumped)      "/usr/bin/lldb-mi" --interpreter=mi --tty=${DbgTerm} 0<"/tmp/Microsoft-MIEngine-In-o6gf3wbo.w0h" 1>"/tmp/Microsoft-MIEngine-Out-pr6267el.0aa"
```
原因：大概是因为系统装了多个版本的 llvm 导致的。。

解决办法：系统PATH中只保留系统自带的 clang，也就是 clang-10 。手动放到 ~/.pathrc 的 clang 11，只好先byebye了。


虽然试过`-DCMAKE_PREFIX_PATH=/home/zz/soft/clang+llvm-11.0.0`参数，但没有效果。。（可能软连接忘记更新导致的，有时间再试试。）


### 报错2：process launch failed: unable to locate lldb-server-10.0.0
```
Warning: Debuggee TargetArchitecture not detected, assuming x86_64.
ERROR: Unable to start debugging. Unexpected LLDB output from command "-exec-run". process launch failed: unable to locate lldb-server-10.0.0
The program '/home/zz/work/cmake_examples/vscode_example/build/linux-x64/testbed' has exited with code 42 (0x0000002a).
```

原因： VSCode 比较傻，只认  `lldb-server-10.0.0` 不认 `lldb-server-10`. 

解决：创建软连接：
```bash
sudo ln -s /usr/bin/lldb-server-10 /usr/bin/lldb-server-10.0.0
```

### 问题3：断点不停，怎么办？

https://github.com/microsoft/vscode-cpptools/issues/5415

试了这帖子贴出的方法，都不行。目前只好切回 gcc