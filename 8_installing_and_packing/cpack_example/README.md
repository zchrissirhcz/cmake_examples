cpack 是用来打包。 啥意思呢？ 假设已经能够执行 `cmake --install .`， 那么把 install 目录压缩一下就可以发布了。

cpack 到底怎么用？

## 最简单方法

CMakeLists.txt
```
blablabla

include(CPack)
```

执行了 cmake --build . 后， 会生成 CPackConfig.cmake 文件； 然后执行
```
cpack
```
即可。

也就是： cpack 默认找当前目录下叫做 CPackConfig.cmake 的文件， 根据它打包。

## 稍微复杂一点

在 CI 环境下， 命令执行路径往往不是“当前目录”。


只指定 CPackConfig.cmake 路径：会在执行 cpack 的目录下生成 xxx.tar.gz (或.zip) 压缩文件：
```
cpack --config /path/to/CPackConfig.cmake
```

如果指定了 -B 和参数， 就在指定参数表示的目录下， 生成 xxx.tar.gz(或.zip):
```
cpack --config /path/to/CPackConfig.cmake -B /path/to/xxx.tar.gz
```

## 再复杂一点

- 我不想要 .tar.gz， 我只想要 .zip
- 我不想用默认生成的名字

安排：

CMakeLists.txt
```
set(CPACK_GENERATOR "ZIP")
set(CPACK_PACKAGE_FILE_NAME "HelloCpp-Linux")
include(CPack)
```
