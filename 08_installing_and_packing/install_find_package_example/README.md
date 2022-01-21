# install_find_package_example

## Intro

在这个例子中:

`hello_project` 目录负责构建出 `libhello.a` 静态库 （以及对应的头文件 `hello.h`)， 并且可以生成 `helloConfig.cmake` 配置文件。

`say_hello_project` 目录负责构建出 `say_hello` 可执行程序， 它依赖于 hello 静态库的 头文件 和 库文件； 通过传入 `hello_DIR` 变量，指向 `helloConfig.cmake` 所在的目录， 顺利的用上 hello 库的头文件、库文件。

其中， `helloConfig.cmake` 是通过 `cmake/helloConfig.cmake.in` 配置文件动态生成的。

## Steps to play
hello_project 工程：
```bash
cd hello_project
mkdir build
cd build
cmake ..
make
make install
```

say_hello_project 工程：
```bash
cd say_hello_project  # 此时可能需要手动改 CMakeLists.txt , 修改 hello_DIR 为你的机器上的路径； 或在调用 cmake 阶段手动传入：cmake -Dhello_DIR=xxxx
mkdir build
cd build
cmake ..
make
```

