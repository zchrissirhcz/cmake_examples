执行一次常规的构建后， 如果想查看具体的编译 和 链接命令， 可通过查看 verbose 输出来做到。


打开 `CMakeCache.txt`,  把 `CMAKE_VERBOSE_MAKEFILE:BOOL=0` 改为 `CMAKE_VERBOSE_MAKEFILE:BOOL=1`.


```cmake
//If this value is on, makefiles will be generated without the
// .SILENT directive, and all commands will be echoed to the console
// during the make.  This is useful for debugging only. With Visual
// Studio IDE projects all commands are done without /nologo.
CMAKE_VERBOSE_MAKEFILE:BOOL=1
```


```bash
cmake --build build --target clean  # make clean
cmake --build build  # 查看编译 和 链接 的具体命令
```