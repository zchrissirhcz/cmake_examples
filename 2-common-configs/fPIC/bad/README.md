## Link Error: relocation R_X86_64_TPOFF32 against `xxx', can not be used when making a shared object; recompile with -fPIC

`otherlib` is a staticlib, and if there is relocation process in `otherlib` (e.g. thread local storage variables, dynamic library calls, PIC/PIE code), when `otherlib` is linked into shared lib `mylib`, and `mylib` is linked by executable `main`, then there might be relocation error during link time:
```cpp
[ 66%] Linking CXX shared library libmylib.so
/usr/bin/ld: libotherlib.a(otherlib.cpp.o): relocation R_X86_64_TPOFF32 against `_ZZ8otherlibvE1a' can not be used when making a shared object; recompile with -fPIC
/usr/bin/ld: failed to set dynamic section sizes: bad value
collect2: error: ld returned 1 exit status
gmake[2]: *** [CMakeFiles/mylib.dir/build.make:98: libmylib.so] Error 1
gmake[1]: *** [CMakeFiles/Makefile2:113: CMakeFiles/mylib.dir/all] Error 2
gmake: *** [Makefile:91: all] Error 2
```

That is to say, when compile a static library `otherlib`, it is always a good practice to enable `-fPIC` on the statlic library's TUs.

The solution in CMakeLists.txt manner, is:
```cmake
set(CMAKE_POSITION_INDEPENDENT_CODE ON) 
```

## Reference

- https://stackoverflow.com/questions/7251573/gcc-relocation-error-at-runtime