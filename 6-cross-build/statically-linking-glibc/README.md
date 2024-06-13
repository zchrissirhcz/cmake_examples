# 静态链接 glibc

## 问题描述
在开发机 ubuntu 18.04 上， glibc 版本 2.28.

在测试部署环境 centos 7.9.2009 上， glibc 版本 2.17.

开发机上编译的程序， 在测试机上运行， 运到报错：
```
./x: /lib64/libm.so.6: version `GLIBC_2.27' not found (required by ./x)
./x: /lib64/libm.so.6: version `GLIBC_2.29' not found (required by ./x)
./x: /lib64/libc.so.6: version `GLIBC_2.34' not found (required by ./x)
./x: /lib64/libstdc++.so.6: version `GLIBCXX_3.4.21' not found (required by ./x)
```

## 尝试docker-问题描述

其中， 工程依赖的外部库文件， 是在 ubuntu 16.04 上构建， glibc 版本也高于 2.17。 如果安装和测试环境相同的 docker 环境， 链接会报错：
```bash
/opt/rh/devtoolset-9/root/usr/libexec/gcc/x86_64-redhat-linux/9/ld: CMakeFiles/x.dir/x.cpp.o: in function `main':
x.cpp:(.text+0x163): undefined reference to `cv::putText(cv::v1_2::Mat&, std::string const&, cv::Matx<int, 2, 1, true>, int, double, cv::Matx<double, 4, 1, true>, int, int, bool)'
collect2: error: ld returned 1 exit status
gmake[2]: *** [x] Error 1
gmake[1]: *** [CMakeFiles/x.dir/all] Error 2
gmake: *** [all] Error 2
```

## 静态链接
在不修改开发机、 测试机、 外部库的构建机器环境情况下， 在开发机上使用**静态链接**， 可以解决上述两个问题.

```cmake
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -static-libgcc -static-libstdc++")
```

```cmake
# 假设你的目标名称是 my_program
target_link_libraries(my_program
    # 静态链接所需库
    -static
    -Wl,--whole-archive
    some_static_library
    -Wl,--no-whole-archive
)
```