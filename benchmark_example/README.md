# benchmark example

[TOC]

## 0. benchmark 库是啥？
https://github.com/google/benchmark

>A microbenchmark support library 

是一个用来测量 C++ 代码性能（运行耗时）的工具库， API 使用层面上类似于 gtest。

## 1. 源码编译安装 benchmark

### 1. 只编 benchmark 库、不带依赖项 gtest 的方式（个人推荐）：
```bash
#!/bin/bash

BUILD_DIR=linux-x64-no-deps
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cmake ../.. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/home/zz/artifact/benchmark/linux-x64 \
    -DBENCHMARK_ENABLE_TESTING=OFF \
    -DBENCHMARK_ENABLE_GTEST_TESTS=OFF

cmake --build . -j
cd ..
```

### 2. 带依赖项（自动联网下载gtest源码编译）的方式（个人不推荐）
```bash
#!/bin/bash

BUILD_DIR=linux-x64
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cmake ../.. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/home/zz/artifact/benchmark/linux-x64 \
    -DBENCHMARK_DOWNLOAD_DEPENDENCIES=ON

cmake --build . -j
cmake --install .
cd ..
```

## 2. apt 方式安装 benchmark 库
```bash
sudo apt install libbenchmark-dev libbenchmark1 libbenchmark-tools
```

## 3. benchmark 库使用注意事项

1). 头文件
```c++
#include <benchmark/benchmark.h>
```

2). 函数参数必须是`benchmark::State& state`:
```c++
void Hello(benchmark::State& state)
{
    for (auto _ : state) {
        double sum = 0;
        for (int i=0; i<10; i++) {
            sum += i;
        }
        //fprintf(stderr, "sum=%.4lf\n", sum);
    }
}
```

3). 注册需要做 benchmark 的函数
```c++
BENCHMARK(Hello);
```

4). 性能测试的循环次数，默认是多少？？
按官方 readme 说法， 是动态的 iteration 数量， 根据前几个 iteration 稳定后的耗时来确定的。

5). 我的性能测试case卡住不动了？
需要在性能测试函数中， 遍历所有 state：
```c++
static void BM_Hello(benchmark::State& state)
{
    for (auto _ : state) {  //!! 这一行， 遍历所有 state。 如果不写， 则整个函数 hang 住。
        double sum = 0;
        for (int i=0; i<10; i++) {
            sum += i;
        }
        //fprintf(stderr, "sum=%.4lf\n", sum);
    }
}
```