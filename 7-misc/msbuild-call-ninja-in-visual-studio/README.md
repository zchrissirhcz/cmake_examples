# 让 msbuild 调用 cmake -> ninja -> cl.exe

## 说明

这个目录存放的是手写 Project1.vcxproj 文件， 最终实现在 VS 里右键点击， 会用 ninja 执行构建的 demo 工程。

.vcxproj 文件里的设定包括：
- configure
- build
- clean
三个部分， 每个部分都是通过执行 .cmd 脚本解决的， 原因：
1） 希望 `Exec Command` 执行多个命令时， 但 `&` 不支持， `&&` 也不行， 放到 .cmd 里却可以
2)  .cmd 脚本中， 由于是调用 ninja， 必须找到 cl.exe, 以及设定相应的 C/C++ 环境， 如头文件包含路径等
3） 为了减少 VS 里输出太多的干扰， 使用了 `> nul 2>&1`
4)  支持 debug/release 分别设定


实际上， 用了这一套， 理论上也能支持交叉编译器， 如 android ndk。

## 前提

安装了 VS2022， CMake, Ninja.

## 使用

用 vs2022 打开 x.sln， 像常规的 VS 工程一样使用即可:
- 构建
- 运行
- 清理
- 打断点
- 函数和头文件跳转