# cmake 生成汇编代码

已有的 StackOverFlow 问答：
[Generate assembly for a target](https://stackoverflow.com/questions/12965019/generate-assembly-for-a-target)

下面是实践后的初步结论

## make xxx.s
经实践， 对于简单的工程（例如只有 hello.cpp, test_hello.cpp）, 可以用如下方式：
```bash
# 若源码位置为 CMAKE_SOURCE_DIR/hello.cpp
make hello.s

# 若源码位置为 src/hello.cpp
make src/hello.s
```

但对于复杂的工程， 例如 ncnn ， 此方法不生效。


## 手动 objdump
手动 objdump 永远是 ok 的方法。

`objdump -d xxx.o`:

```bash
cd /home/zz/work/ncnn/build/linux-x64-simple
objdump -d src/CMakeFiles/ncnn.dir/cpu.cpp.o
```


