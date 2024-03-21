# 交叉编译时传入 `-DXX=YY`， 打印出的值为空吗？

## 典型场景

```bash
cmake \
    -S . \
    -B build \
    -DCMAKE_TOOLCHAIN_FILE=xxx.toolchain.cmake \
    -DXX=YY
```

其中两项必须项:
- `-DCMAKE_TOOLCHAIN_FILE=xxx.toolchain.cmake` 是指定交叉编译工具链， 最常见的是 android 和 ohos 的;
- `-DXX=YY` 是自行定义的变量， 比如打算在 `CMakeLists.txt` 里使用， 或者在 `xxx.toolchain.cmake` 里使用。

## 问题描述

在 `CMakeLists.txt` 里打印 `XX` 的值， 发现是空的。 在 `xxx.toolchain.cmake` 里打印 `XX` 的值， 时而有效， 时而无效。

## 复现 && 解决方案

写了简单的 `hello1.toolchain.cmake`， 用于复现问题。

写了简单的 `hello2.toolchain.cmake`， 用于解决问题。

使用 `OHOS_SDK_NATIVE_PATH` 作为 `XX` 的变量的具体名字。

差别在于:
```cmake
set(CMAKE_TRY_COMPILE_PLATFORM_VARIABLES
  OHOS_SDK_NATIVE_PATH
)
```

一点点解释：
- `-DCMAKE_TOOLCHAIN_CMAKE=hello1.toolchain.cmake` 指定了 toolchain 文件， 这个文件会被多次处理；
- 从命令行传入的 `-DOHOS_SDK_NATIVE_PATH=/home/zz/toolchains/ohos/native/4.0.10.5`， 第一次处理 `hello1.toolchain.cmake` 时， `OHOS_SDK_NATIVE_PATH` 是有值的
- 第二次处理 `hello1.toolchain.cmake` 时， `OHOS_SDK_NATIVE_PATH` 没有值， 原因是没有放在 `CMAKE_TRY_COMPILE_PLATFORM_VARIABLES` 中
- 可以对比两个 `CMakeConfigureLog.yaml` 文件查看：
    ![](compare_cmake_configure_log.png)
- 对比实验时， 需要确保是 fresh build， 删除上一次 build 内容。 如果没删除， 是做 rebuild， 现象不一样

## 结论

对于交叉编译， 也就是传入 `-DCMAKE_TOOLCHAIN_FILE=xxx.toolchain.cmake` 时， 同时从命令行传入 `-DXX=YY`， 并且在 `xxx.toolchain.cmake` 里使用， 那么应当在 `xxx.toolchain.cmake` 里， 把 `XX` 添加到 `CMAKE_TRY_COMPILE_PLATFORM_VARIABLES` 变量中， 来确保每次处理 `xxx.toolchain.cmake` 时， `XX` 的值是一样的。