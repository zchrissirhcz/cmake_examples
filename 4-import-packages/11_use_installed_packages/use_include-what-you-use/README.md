# include-what-you-use CMake Example

用来检查不合适的头文件引入。

## 编译安装 include-what-you-use
include-what-you-use 这个工具，是和 Clang 编译器版本绑定的，基本上需要自行编译安装。

但是不能随便一个 Clang 版本都能用， 必须是 include-what-you-use 代码仓库里有的分支才行。比如当前（2021年12月01日09:46:54）最高支持到 clang-12， 我用的 clang-13 就不支持。

**安装clang-12**

为了节约时间，直接 apt 装 clang-12：
```bash
sudo apt install clang-12
sudo apt install libclang-12-dev
```

**下载 include-what-you-use 代码，切分支**

```bash
cd ~/work/github
git clone https://github.com/include-what-you-use/include-what-you-use
cd include-what-you-use
git checkout -t origin/clang_12
```

**编译 include-what-you-use**

```bash
mkdir build
cd build
cmake .. -DCMAKE_PREFIX_PATH=/usr/lib/llvm-12 \
    -DCMAKE_INSTALL_PREFIX=/home/zz/soft/iwyu-clang12 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=clang-12 \
    -DCMAKE_CXX_COMPILER=clang++-12

cmake --build . -j
cmake --install .
```

## 命令行用法
直接把 include-what-you-use 当编译器用即可， 支持原有编译器的所有参数， 如果是 include-what-you-use 特有的参数， 则通过 `-Xiwyu` 前缀传入， 例如 `-Xiwyu --verbose=4`, `-Xiwyu --no_comments`.

最简单的例子如下：
```c++
#include <stdio.h> // this line is expected to be reported
int main()
{
    return 0;
}
```

执行检查：
```bash
(base) zz@locahost% include-what-you-use --version
include-what-you-use 0.16 (git:78577f2) based on Ubuntu clang version 12.0.0-3ubuntu1~20.04.4
(base) zz@localhost% include-what-you-use main.cpp 

main.cpp should add these lines:

main.cpp should remove these lines:
- #include <stdio.h>  // lines 1-1

The full include-list for main.cpp:
---
```

## CMake 用法

具体例子见 [global_usage](global_usage) 和 [per_target_usage](per_target_usage) 目录。以下是通俗解释：

原有的 C++ 工程基础上， <del>编译器不变</del>、 CMakeLists.txt 加一句即可：

```cmake
set(CMAKE_CXX_INCLUDE_WHAT_YOU_USE "include-what-you-use")
```
其中，我已经把 `include-what-you-use` 这一可执行文件所在目录放入系统 PATH 环境变量； 如果没有放入 PATH， 则这里填绝对路径即可。
还可以将 `CMAKE_CXX_INCLUDE_WHAT_YOU_USE` 的值，设为 `"include-what-you-use;-Xiwyu;--verbose=7;-Xiwyu;--cxx17ns"` 这样的带参数的版本。

（实测：手动编译的 include-what-you-use 绑定 clang-12， 工程用 clang-13，能良好使用； 但include-what-you-use改为apt安装版本，则无法使用。）

然后按原本的编译方式编译，可以看到 include-what-you-use 产生的额外输出：

```
(base) zz@localhost% cmake ..
-- The C compiler identification is Clang 13.0.0
-- The CXX compiler identification is Clang 13.0.0
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working C compiler: /home/zz/soft/llvm-13.0.0/bin/clang - skipped
-- Detecting C compile features
-- Detecting C compile features - done
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: /home/zz/soft/llvm-13.0.0/bin/clang++ - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Configuring done
-- Generating done
-- Build files have been written to: /home/zz/work/test/include_check/build
(base) zz@localhost% make
[ 50%] Building CXX object CMakeFiles/testbed.dir/main.cpp.o
Warning: include-what-you-use reported diagnostics:

/home/zz/work/test/include_check/main.cpp should add these lines:

/home/zz/work/test/include_check/main.cpp should remove these lines:
- #include <stdio.h>  // lines 1-1

The full include-list for /home/zz/work/test/include_check/main.cpp:
---

[100%] Linking CXX executable testbed
[100%] Built target testbed
```

## References
- https://github.com/include-what-you-use/include-what-you-use/issues/975
- https://stackoverflow.com/questions/30951492/how-to-use-the-tool-include-what-you-use-together-with-cmake-to-detect-unused-he