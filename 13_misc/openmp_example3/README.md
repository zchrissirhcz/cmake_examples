# openmp_example2

## 安装编译器
需要准备 C/C++ 编译器。

apt 中的 gcc/g++/clang/clang++ 均可, e.g.

```bash
sudo apt install gcc g++
sudo apt install clang clang++
```

## 安装openmp库

由于我用的是 clang-llvm 最新dev版， 从 https://apt.llvm.org/ 配置了apt进行下载，需要单独装 openmp 库:
```bash
 apt-get install libomp-14-dev
```
如果是自行从源码编译安装的 clang-llvm 编译器， 注意在 cmake 阶段指明要编译 openmp 组件， 并在安装后设置 LB_LIBRARY_PATH。


## 编译和链接选项，都要设定openmp
这个例子展示了： 当可执行目标 B 依赖于静态库目标 A， A本身依赖的 OpenMP 可以设为 PRIVATE 链接， 从而不影响到 B。

对一个库或可执行目标， 对应的代码实现里用了 OpenMP 的东西：
- 用了 #pragma omp parallel for 这样的预编译指令， 需要编译和链接选项都开启openmp
- 只用了 omp_set_dynamic() 这样的 openmp API， 只要链接 openmp 库就可以了
- 但往往， `#pragma omp` 这样的预编译语句一定有, openmp API 函数调用不一定有

因此通常来说应该对一个 target 分别设定openmp的编译和链接选项， 才能让 openmp 真的生效。

## 区分静态和动态的openmp库
android ndk 平台的openmp库，有动态库和静态库两个： libopenmp.a, libopenmp.so。
对于类似于 ncnn 的 benchncnn 这样的 android 控制台可执行程序， 最方便的是链接静态库； 而 `find_package(OpenMP)` 调用 cmake 自带的 FindOpenMP.cmake 只能找到openmp动态库。

查看 FindOpenMP.cmake 得知， 里面用 find_library 找的 openmp 库的位置。于是可以覆盖 find_library 依赖的 `CMAKE_FIND_LIBRARY_SUFFIXES` 变量， `find_package(OpenMP)` 后再恢复。

更进一步， 封装了 `find_static_package()` 和 `find_shared_package()` 两个通用的宏， 封装了 `target_link_openmp()` 宏（能够同时处理 cmake<3.9 和 >= 3.9 版本兼容问题）。

具体看 [CMakeLists.txt](CMakeLists.txt)