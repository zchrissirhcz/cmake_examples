# Debug CMake Scripts in VSCode via CMake Tools extension

CMake >= 3.27 required.
This is enabled by `cmake --debugger --debugger-pipe` introduced since CMake 3.27. These parameters will be received by the debugee `test.cmake` script.

Reference: 
- https://zhuanlan.zhihu.com/p/708149425
- https://github.com/microsoft/vscode-cmake-tools/blob/main/docs/debug.md
- https://devblogs.microsoft.com/cppblog/debug-vcpkg-portfiles-in-cmake-script-mode-with-visual-studio-code/
- https://github.com/microsoft/vscode-cmake-tools/discussions/3891