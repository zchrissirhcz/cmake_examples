# dll path example

## 方法描述
在 Windows 平台导入依赖库， 若依赖库的库文件是 .dll 形式（动态库），除了常规的两件事：
- 头文件搜索目录
- 库文件路径

还需要搞定运行时找不到 dll 的问题， 例如这些“土法”：
- 手动拷贝 dll 到运行目录
- 或者， 把 dll 所在目录放到 PATH 中
- 或者， 不弄动态库了， 想办法编译出静态库， 只连接静态库

实际上可以优雅的设定, 设置 target 的 `VS_DEBUGGER_WORKING_DIRECTORY` 属性为 dll 所在目录即可：

```cmake
set_target_properties(testbed PROPERTIES
    VS_DEBUGGER_WORKING_DIRECTORY "D:/artifacts/freeglut/3.2.1/vs2019-x64/bin"
)
```

## 举例
OpenCV， freeglut， zlib， ffmpeg ... 好多库都是这样的

## References
https://stackoverflow.com/a/58687851/2999096