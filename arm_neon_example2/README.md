# ARM NEON Example2

原始代码地址：

https://github.com/dawidborycki/NeonIntrinsics-Android/blob/master/app/src/main/cpp/native-lib.cpp


本文件夹下的文件，剔除了JNI相关的代码，直接生成可执行文件，在root过的小米手机（或者树莓派、EAIDK等ARM开发板上）可以运行。

基于本目录下的优化实现，给原始repo提交了PR并被合并（不包含fastMalloc相关代码）。

基于原始repo的Android工程，以及使用带fastMalloc实现的代码，在小米8上运行截图：

![](./save.jpg)