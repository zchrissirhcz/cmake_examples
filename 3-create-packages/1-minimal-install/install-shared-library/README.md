Build with commands:
```
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --target install
```

Check the RUNPATH of installed executable `demo`:

```bash
readelf -d build/install/bin/demo
```

```bash
Dynamic section at offset 0x2da8 contains 29 entries:
  标记        类型                         名称/值
 CMakeLists.txt
 0x0000000000000001 (NEEDED)             共享库：[libfoo.so]
 0x0000000000000001 (NEEDED)             共享库：[libc.so.6]
 0x000000000000001d (RUNPATH)            Library runpath: [$ORIGIN/../lib]
 0x000000000000000c (INIT)               0x1000
 0x000000000000000d (FINI)               0x116c
 ...
```

Reference: https://cmake.org/cmake/help/latest/prop_tgt/INSTALL_RPATH.html