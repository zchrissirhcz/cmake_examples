## sources

https://zhuanlan.zhihu.com/p/460259475

https://github.com/MegEngine/MegEngine/blob/9809871e1316d19ac25a864c166df33006059887/dnn/include/megdnn/arch.h#L49



## notes
特点： 执行程序时，根据当前机器的cpuinfo的最高支持，去匹配代码实现中的最高实现。

例如 `clang++ -msse4.2 testbed.cpp` 但仍然会执行 avx2 的版本：
```c++
__attribute__ ((target ("avx2")))
int foo ()
{
  printf("foo version for avx2, not implemented, now lets call sse4.2 version\n");
  return 1;
}
```

但相关的SIMD平台宏定义，仍然是由 `-msse4.2` 方式传入的，因此下述函数：
```c++
void print_arch()
{
#if __SSE4_1__
  printf(">>> have __SSE4_1__\n");
#endif

#if __SSE4_2__
  printf(">>> have __SSE4_2__\n");
#endif

#if __POPCNT__
  printf(">>> have __POPCNT__\n");
#endif

#if __AVX__
  printf(">>> have __AVX__\n");
#endif

#if __AVX2__
  printf(">>> have __AVX2__\n");
#endif
}
```
只会输出
```
>>> have __SSE4_1__
>>> have __SSE4_2__
```