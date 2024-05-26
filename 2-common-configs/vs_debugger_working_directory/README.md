# VS_DEBUGGER_WORKING_DIRECTORY

在 Visual Studio 中， 可执行文件（如 demo.exe) 的执行往往让人迷惑， 有三个相关的路径， 默认它们是不同的：
- cmake configure 阶段指定的 -B 目录， 例如 `build`
- 生成的可执行文件的路径, 例如 `build/Debug/demo.exe` 和 `build/Release/demo.exe`
- 执行可执行文件的路径， 即 “工作目录”，默认值为 `$(ProjectDir)`

当你的 C/C++ 代码中使用相对路径，可以保持使用 `input.txt` 这样简单的写法， 将 “工作目录” 改掉即可：

```cmake
set_target_properties(
  demo PROPERTIES
  VS_DEBUGGER_WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}" # 设为了和当前 CMakeLists.txt 同级目录
)
```

![](vs_debugger_working_directory.png)

参考:
- https://cmake.org/cmake/help/latest/prop_tgt/VS_DEBUGGER_WORKING_DIRECTORY.html
- https://stackoverflow.com/questions/41864259/how-to-set-working-directory-for-visual-studio-2017-rc-cmake-project