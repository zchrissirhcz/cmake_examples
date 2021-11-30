# LibClang CMake example

在这个例子中， 通过 CMake 配置了 LibClang 这一库作为依赖项。

LibClang 是一个 C 接口的动态库， 编译 LLVM 后，需要手动添加安装目录下的 lib 子目录到 LD_LIBRARY_PATH。

main.cpp 作为例子， 简单的分析（parse）了 header.hpp， 根据 cursor （AST节点）的类型进行输出。

注意： LibClang 不适合 C++ 的源代码生成， 功能有限。

## References
[ Using libclang to Parse C++ (aka libclang 101) (1270 words) ](https://shaharmike.com/cpp/libclang/)