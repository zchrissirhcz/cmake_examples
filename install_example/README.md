# install_example

## 说明

在这个例子中展示最基本的 install 用法 （**过于基础，没生成 findXXX.config**）

创建了一个静态库目标 hello

创建了一个可执行目标 say_hello ， 依赖于 hello 库。

在 CMakeLists.txt 最开头，设定了默认的 `CMAKE_INSTALL_PREFIX` 为编译产出目录下的 install 子目录 (`CMAKE_BINARY_DIR/install`) .

安装涉及：
- 头文件 hello.h ， 安装到  `${CMAKE_INSTALL_PREFIX}/include/hello.h`
- 静态库文件 libhello.a ， 安装到 `${CMAKE_INSTALL_PREFIX}/lib/libhello.a`
- 可执行文件 say_hello ， 安装到 `${CMAKE_INSTALL_PREFIX}/bin/say_hello`

```
(base) zz@home% tree
.
├── bin
│   └── say_hello
├── include
│   └── hello.h
└── lib
    └── libhello.a
```

## 实操
```bash
mkdir build
cd build
cmake ..
cmake --build .
cmake --install .
```

或者 linux/Mac 通用的：
```bash
mkdir build
cd build
cmake ..
make
make install
```