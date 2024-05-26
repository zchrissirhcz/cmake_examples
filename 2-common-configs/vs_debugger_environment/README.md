# VS_DEBUGGER_ENVIRONMENT

在 Visual Studio 中， 当可执行目标（如demo.exe) 需要 .dll 文件才能正常运行时， 你会遇到的问题：
- 程序运行， 一上来就提示 .dll 找不到, 如 opencv_world490d.dll
- 程序运行， 不提示 .dll 找不到， 但运行结果不符合预期， 例如没找到 opencv_videoio_ffmpeg490_64.dll 时， `cap.get(cv::CAP_PROP_FRAME_COUNT)` 结果为 -1

解决思路是让运行的程序找到 .dll 文件， 具体做法有多种形式：
- 拷贝 .dll 文件到程序的启动目录（注意，不一定是 demo.exe 所在目录）
- 永久添加 .dll 所在目录到 PATH 环境变量中
- 拷贝 .dll 文件到已经在 PATH 环境变量的路径中， 如 C:/system32
- 临时修改 PATH，把需要的 .dll 所在的目录临时加入 PATH （推荐）

前面几个方法，潜在的问题：
- 0xC0000135 的错误码： .dll 文件没找到
- 0xc000007b 的错误码： 32位和64位的 .dll 文件混用了，例如 PATH 里的多个目录同时存在，先被找到的是 32位的， 但当前程序需要64位的
- 不同版本的 .dll 的冲突： 例如构成 PATH 的不同目录下， 存在不同版本的 zlib.dll， 低版本有bug， 而你需要高版本的 

推荐的设定方式， 是临时修改 PATH， 随用随设置的方式把 .dll 路径加入进来。 在 CMake 中提供了 `VS_DEBUGGER_ENVIRONMENT` 属性，设置方式举例:
```cmake
set_target_properties(
  demo PROPERTIES
  VS_DEBUGGER_ENVIRONMENT "PATH=C:/pkgs/opencv/build/x64/vc16/bin;%PATH%"
)
```