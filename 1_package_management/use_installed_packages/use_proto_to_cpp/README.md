# proto_to_cpp_example


## steps

### step1: 装protobuf

编译安装protobuf，建议至少3.6版以上

可以参考`build-install-protobuf-vs2019-x64.cmd`文件，本人尝试的是当前最新（2021-3-19，protobuf 3.15.6)版本。

### step2: 用protobuf

本目录下的 CMakeLists.txt, src目录， proto目录，作为样板工程，能从.proto生成cpp文件和h文件。

注意，使用了`protobuf_generate_cpp()`这一cmake函数。如果要生成python文件，考虑使用如下（暂未尝试）：
```cmake
protobuf_generate(
 LANGUAGE cpp
 TARGET <YOUR_TARGET_NAME> 
 PROTOS Foo.proto)
```


## references

- [CMake can't find Protobuf `protobuf_generate_cpp`](https://stackoverflow.com/questions/52533396/cmake-cant-find-protobuf-protobuf-generate-cpp)

- [protobuf简单使用](https://www.cnblogs.com/zjutzz/p/11158617.html)