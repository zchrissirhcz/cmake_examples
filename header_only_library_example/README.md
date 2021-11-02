# header_only_library CMake example

对于C++的模板类，如果模板类型不做限制，并且对外提供使用，则模板类的声明和实现，都放在同一个 .h/.hpp 中。

此时若整个库只有这一个 .h/.hpp 文件， 它就是一个 header-only library。

相比于普通的添加静态库目标， header-only 库目标的创建，需要添加 `INTERFACE` 关键字：

```cmake
add_library(array INTERFACE
    array.hpp
)
```

- https://stackoverflow.com/questions/60604249/how-to-make-a-header-only-library-with-cmake
- https://cmake.org/cmake/help/latest/command/add_library.html#interface-libraries