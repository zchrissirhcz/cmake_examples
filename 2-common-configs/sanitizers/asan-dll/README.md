## Problem
When using OpenCV prebuilt (from official, e.g. 4.9.0), you use opencv_world490.dll, by using the following cmake:
```cmake
  set_target_properties(
    demo PROPERTIES
    VS_DEBUGGER_ENVIRONMENT "PATH=D:/pkgs/opencv/4.9.0/build/x64/vc16/bin;%PATH%"
  )
```

And one day you encounter a crash, so you decide to enable Address Sanitizer, globally:
```cmake
add_compile_options(/fsanitize=address)
add_link_options(/fsanitize=address)
```

and you also update your Visual Studio 2022 to the very latest, say 17.10 (>= 17.7), and it runs with error:

> C:\demo\build\Debug\demo.exe (进程 1352)已退出，代码为 -1073741515。

![](asan_dll_not_found.png)

But if you just use a very simple hello-world-level .c/.cpp file, without linking OpenCV libs, it just works.

## Cause

> If you are seeing this immediately after updating to Visual Studio 2022 17.7 Preview 3 and you are statically linking to the C Runtime (/MT, /MTd), that binary has a new dependency on the ASan DLL named and must be included in the environment. Please update the PATH to include clang_rt.asan_dynamic-x86_64.dll (x64) or clang_rt.asan_dynamic-i386.dll (x86).

That is to say, both `MT(d)` and `MD(d)` will require `clang_rt.asan_dynamic-x86_64.dll` for `x64` arch.

https://devblogs.microsoft.com/cppblog/msvc-address-sanitizer-one-dll-for-all-runtime-configurations/

## Solution

Put path of `clang_rt.asan_dynamic-x86_64.dll` to PATH, temporarily. i.e. put it into `VS_DEBUGGER_ENVIRONMENT` property of your cmake target.

### Per-target

Hardcode is straight-forward:
```cmake
set_target_properties(
  demo PROPERTIES
  VS_DEBUGGER_ENVIRONMENT "PATH=D:/pkgs/opencv/4.9.0/build/x64/vc16/bin;C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.40.33807/bin/Hostx64/x64;%PATH%"
)
```

Or, just make it cleaner:
```cmake
# get dll dirs: opencv dll, asan dll
get_filename_component(OpenCV_BIN_DIR "${OpenCV_DIR}/../bin" ABSOLUTE)
get_filename_component(CXX_COMPILER_DIR ${CMAKE_CXX_COMPILER} DIRECTORY) # e.g. C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.40.33807/bin/Hostx64/x64

# add dll dirs to runtime path on target
set_target_properties(
  demo PROPERTIES
  VS_DEBUGGER_ENVIRONMENT "PATH=${OpenCV_BIN_DIR};${CXX_COMPILER_DIR};%PATH%"
)
```

### Globally

CMake 3.27 introduces `CMAKE_VS_DEBUGGER_ENVIRONMENT` variable, whose value will be the initial value of each target. So just set this variable before each target is created:

```cmake
get_filename_component(OpenCV_BIN_DIR "${OpenCV_DIR}/../bin" ABSOLUTE)
get_filename_component(CXX_COMPILER_DIR ${CMAKE_CXX_COMPILER} DIRECTORY)
set(CMAKE_VS_DEBUGGER_ENVIRONMENT "PATH=${OpenCV_BIN_DIR};${CXX_COMPILER_DIR};%PATH%")
```
