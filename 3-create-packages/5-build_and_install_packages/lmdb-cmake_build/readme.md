# lmdb cmake scripts

## 使用步骤
下载源码，切换分支，并且打补丁（来自[willyd](https://github.com/willyd/caffe-builder/blob/master/packages/lmdb/lmdb_45a88275d2a410e683bae4ef44881e0f55fa3c4d.patch))

```bat
cd $WORK
git clone https://github.com/LMDB/lmdb
cd lmdb
git checkout -b LMDB_0.9.18 LMDB_0.9.18
git apply ../lmdb-cmake/lmdb_45a88275d2a410e683bae4ef44881e0f55fa3c4d.patch --ignore-whitespace --whitespace=nowarn --verbose
```

```bat
cd $WORK/lmdb-cmake/build
run vs2013-x64.bat
```

## windows补丁说明
`mdb_dump.c`用到unix下特有的文件，windows下的补丁：
- src/getopt.c
- src/getopt.h
- src/unistd.h
来自 https://github.com/barrysteyn/scrypt-windows


## related ref
[https://blog.csdn.net/10km/article/details/73635424](windows下msvc/mingw静态编译 lmdb的CMakeLists.txt)
缺点：没有生成lmdb-config.cmake
