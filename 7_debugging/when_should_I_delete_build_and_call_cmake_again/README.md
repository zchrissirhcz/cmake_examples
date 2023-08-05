对于 CMakeLists.txt 生成的 Visual Studio 工程:
- 对于 add_executable() 中是手动显式指定文件名字方式， 并且现在改变了文件顺序， 则需要删除 build， 重新生成。
    - 一个具体的例子是：对于 ODRV 的一个复现工程， 不同的源码文件顺序， 影响了 `ASAN` / `/RTC1` 复现问题。
- 对于 add_executable() 中的源码是通过 GLOB 方式获取的， 在增加、删除了其中的 .c/.cpp 文件后， 需要删除 build， 重新生成。
