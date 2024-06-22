## Linux-x64, default RPATH

Create an executable `test` which links to an shared library `libhello.so`. Search `RPATH` or `RUNPATH` in `test`, the ELF executable file.

```bash
cd hello/build
./linux-x64.sh

cd ../..
cd build
./linux-x64.sh

readelf -d linux-x64/test

#readelf -d linux-x64/test | ag 'RUNPATH|RPATH'
```

```
Dynamic section at offset 0x2dd8 contains 28 entries:
  标记        类型                         名称/值
 0x0000000000000001 (NEEDED)             共享库：[libhello.so]
 0x0000000000000001 (NEEDED)             共享库：[libc.so.6]
 0x000000000000001d (RUNPATH)            Library runpath: [/home/zz/work/cmake_examples/2_global_and_target_settings/rpath/hello/build/linux-x64]
 0x000000000000000c (INIT)               0x1000
 0x000000000000000d (FINI)               0x1160
 0x0000000000000019 (INIT_ARRAY)         0x3dc8
 0x000000000000001b (INIT_ARRAYSZ)       8 (bytes)
 0x000000000000001a (FINI_ARRAY)         0x3dd0
 0x000000000000001c (FINI_ARRAYSZ)       8 (bytes)
 0x000000006ffffef5 (GNU_HASH)           0x3a0
 0x0000000000000005 (STRTAB)             0x470
 0x0000000000000006 (SYMTAB)             0x3c8
 0x000000000000000a (STRSZ)              240 (bytes)
 0x000000000000000b (SYMENT)             24 (bytes)
 0x0000000000000015 (DEBUG)              0x0
 0x0000000000000003 (PLTGOT)             0x4000
 0x0000000000000002 (PLTRELSZ)           24 (bytes)
 0x0000000000000014 (PLTREL)             RELA
 0x0000000000000017 (JMPREL)             0x660
 0x0000000000000007 (RELA)               0x5a0
 0x0000000000000008 (RELASZ)             192 (bytes)
 0x0000000000000009 (RELAENT)            24 (bytes)
 0x000000006ffffffb (FLAGS_1)            标志： PIE
 0x000000006ffffffe (VERNEED)            0x570
 0x000000006fffffff (VERNEEDNUM)         1
 0x000000006ffffff0 (VERSYM)             0x560
 0x000000006ffffff9 (RELACOUNT)          3
 0x0000000000000000 (NULL)               0x0
```

## Explicity set RPATH for ELF executable
The cmake call is
```cmake
set_target_properties(test PROPERTIES BUILD_RPATH "$ORIGIN;$ORIGIN/../lib")
```

The result: the value of `RUNPATH` now starts with "$ORIGIN:$ORIGIN/../lib"

```
Dynamic section at offset 0x2dd8 contains 28 entries:
  标记        类型                         名称/值
 0x0000000000000001 (NEEDED)             共享库：[libhello.so]
 0x0000000000000001 (NEEDED)             共享库：[libc.so.6]
 0x000000000000001d (RUNPATH)            Library runpath: [$ORIGIN:$ORIGIN/../lib:/home/zz/work/cmake_examples/2_global_and_target_settings/rpath/hello/build/linux-x64]
 0x000000000000000c (INIT)               0x1000
 0x000000000000000d (FINI)               0x1160
 0x0000000000000019 (INIT_ARRAY)         0x3dc8
 0x000000000000001b (INIT_ARRAYSZ)       8 (bytes)
 0x000000000000001a (FINI_ARRAY)         0x3dd0
 0x000000000000001c (FINI_ARRAYSZ)       8 (bytes)
 0x000000006ffffef5 (GNU_HASH)           0x3a0
 0x0000000000000005 (STRTAB)             0x470
 0x0000000000000006 (SYMTAB)             0x3c8
 0x000000000000000a (STRSZ)              263 (bytes)
 0x000000000000000b (SYMENT)             24 (bytes)
 0x0000000000000015 (DEBUG)              0x0
 0x0000000000000003 (PLTGOT)             0x4000
 0x0000000000000002 (PLTRELSZ)           24 (bytes)
 0x0000000000000014 (PLTREL)             RELA
 0x0000000000000017 (JMPREL)             0x678
 0x0000000000000007 (RELA)               0x5b8
 0x0000000000000008 (RELASZ)             192 (bytes)
 0x0000000000000009 (RELAENT)            24 (bytes)
 0x000000006ffffffb (FLAGS_1)            标志： PIE
 0x000000006ffffffe (VERNEED)            0x588
 0x000000006fffffff (VERNEEDNUM)         1
 0x000000006ffffff0 (VERSYM)             0x578
 0x000000006ffffff9 (RELACOUNT)          3
 0x0000000000000000 (NULL)               0x0
```

## Explicitly disable RPATH

```cmake
set(CMAKE_SKIP_RPATH ON)
```

Then, the generated executable file `test` won't have an RPATH/RUNPATH, even if you specify
```cmake
set_target_properties(test PROPERTIES BUILD_RPATH "$ORIGIN;$ORIGIN/../lib")
```
