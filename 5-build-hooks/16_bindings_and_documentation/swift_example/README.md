# swift_example

特点：
- 语言： 完全使用 Swift 语言， 不包括 C/C++/ObjC/汇编
- 构建：
    - 不支持 make 作为 generator，用 Ninja 即可
    - cmake + ninja 方式 (不需要装 XCode, 装有命令行工具即可)
    - cmake + XCode (理论上可用，暂未尝试)

## 写 CMakeLists.txt
开启语言支持：
```cmake
project(swift_example)
enable_language(Swift)
```
或
```
project(swift_example LANGUAGES Swift)
```

其他按常规 cmake 写。

## 编译
```bash
mkdir build
cd build
cmake .. -GNinja
ninja
./testbed
```

## 运行输出
```
(base) ➜  build git:(master) ✗ ./testbed 
Greeting the world
Hello world! Your random number is 4
World has been greeted! Congratulations!
```