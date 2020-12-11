# external add example

## Intro

有时会觉得，在 git 仓库里放 submodule 需要额外手动执行命令，能不能让 cmake 帮我们执行 git clone 操作呢？

利用 `ExternalProject_Add()` 这一 cmake 命令可以做到。

这里的例子是：git clone googletest 这一测试框架。

注意，执行 cmake 后并不真的执行 git clone，而是在对应的generator（例如Visual Studio）中做了配置，编译 target 时会触发 git clone 操作。


## Refs

https://stackoverflow.com/a/38026254/2999096

https://github.com/google/googletest/blob/master/googletest/samples/