OpenMP例子

目前的CMakeLists.txt有点问题，编可执行文件时，LDFLAGS似乎每个平台不太一样；也还不知道如何切换gcc和clang各自的openmp。


用到的样例cpp代码，在PC vs2017 Release模式运行，反倒是没有OpenMP的会更快。需要找一个更合适的例子。