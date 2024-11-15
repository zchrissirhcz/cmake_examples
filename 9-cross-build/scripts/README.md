# cross-build-scripts

This is the 'Hello World' example (executable file) for C/C++, with various generator specified in each individual script file under `build` directory.

## Android Platform

build/android-arm32-build.sh for building android armveabi-v7a abi executable/library

build/android-arm64-build.sh for building android arm64-v8a abi executuable/library

build/android-arm32-run.sh for copying armeabi-v7a executable file to android device and run

build/android-arm64-run.sh for copying arm64-v8a executable file to android device and run

Note: you may change `ANDROID_DIR` to your one.

Note2: if your develop machine is Windows System, use build/android-xxx-yyy.cmd alternative script files (.sh => .cmd)

Note3: if you are on Linux develop machine and first time connect Android phone via USB line, it is required to add udev rule, see [setup-udev-and-adb-cheet-sheet.md](setup-udev-and-adb-cheet-sheet.md) for how to add udev rule and most often used adb commands' usage.

## Visual Studio Platform

see build/vs20xx.cmd

Note: to use clang-cl as generator, first install Clang-CL from Visual Studio Installer.

Note2: to use 64bit compiler (default is using 32bit cl.exe when `<= vs2017`), passing `-T host=x64`:
```
cmake -G "Visual Studio 15 2017" -A x64 -T host=x64
```
Which solves the problem of "堆空间不足"(3.5GB)

To enable visual studio developer environemnt, reference: [Visual Studio Developer Command Prompt and Developer PowerShell](https://learn.microsoft.com/en-us/visualstudio/ide/reference/command-prompt-powershell?view=vs-2022)

## XCode

see build/xcode.sh

## CLion

build/clion-android-arm64.cmd for building android arm64 CLion project

build/clion-mingw-w64.cmd for building mingw64 CLion project

## OHOS (Open-source Harmony Operating System，鸿蒙) Platform

build/ohos-arm64-v8a.bat
