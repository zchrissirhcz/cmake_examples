# compile database example

## intro
通常是在 MSVC 之外的编译器，如 GCC/Clang， MinGW， Android NDK，不指定generator，或generator为ninja的时候， 可以通过设定 CMAKE_EXPORT_COMPILE_COMMANDS 为 ON（或1），使得 cmake 产生一个名为 `compile_commands.json` 的文件。

这个文件有啥用？ 我用 clangd + codelldb 这两个 VSCode 插件， Vim/NVim 也类似的情况， 会根据此数据库文件进行解析，解析后可进行源码的函数跳转。某些情况下比微软的VSCode C++插件（cpptools）更准确。

另外像 sourcetrail 这样的源码分析工具， 也依赖于 compile_commands.json.

## usage
可以在每个C/C++项目的CMakeLists.txt里设定开启：
```cmake
cmake_minimum_required(VERSION 3.20)
project(xxx)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON) #!! 这句
```

但如果项目的cmakelists.txt没有写上面这句，也可以在调用cmake时自行开启：
```bash
mkdir build && cd build
cmake .. \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON  #!! 这句
```

但如果每个项目都这样加，太繁琐; 可以设置shell环境变量，cmake会读取（since cmake 3.17）
```bash
export CMAKE_EXPORT_COMPILE_COMMANDS=1
```

