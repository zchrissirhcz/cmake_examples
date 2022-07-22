# install example4

## 问题描述和解决方法
解决的问题是：

> 手头没有源码，只有头文件和库文件； 希望用 find_package() 方式在 cmake 中作为依赖项配置

解决方法是用 `INSTALL()` 命令，分别安装头文件和库文件， 并注意：
- 不需要定义为 IMPORTED 类型的 library target. `INSTALL(TARGET)` 命令并不支持 IMPORTED 目标
- 需要分别设置4种 BUILD_TYPE 的库， 通常是同一个库，有时候有 release 和 debug 库则可以分别写

## 例子
EasyX 是一个 Windows only 的库， 原本目的是兼容 Borland Graphics 这个上古图形界面。

其安装方式简单，从官方下载后双击安装即可。安装的内容是典型的依赖文件
- 头文件 graphics, easyx.h
- 库文件 EasyXa.lib, EasyXW.lib

考虑这样的场景：把自己写的基于 EasyX 的工程交给别人， 对方电脑未必有 EaxyX。那么基于 CMake 的配置能够看出依赖项， 更直观。

此时可以手动配置：
1. 用 7zip 解压 EasyX_20220116.exe, 我放到 d:/artifacts/easyx/20220116 目录。
2. 手写 easyxConfig.cmake 文件（已在本目录提供），并放在个人安装的根目录下，
3. 在依赖于 EaxyX 的项目中基于 CMake 配置
```cmake
set(easyx_DIR "d:/artifacts/easyx/20220116")
find_package(easyx REQUIRED)
target_link_libraries(xx_target easyx)
```

## References
- [Can I install shared imported library?](https://stackoverflow.com/questions/41175354/can-i-install-shared-imported-library#:~:text=1%20Answer%0A1.%20CMake%20doesn%27t%20allow%20to%20install%20IMPORTED,modify%20it%20for%20adjust%20some%20properties%20like%20)
- https://gitlab.kitware.com/cmake/cmake/-/issues/22959
- https://easyx.cn/