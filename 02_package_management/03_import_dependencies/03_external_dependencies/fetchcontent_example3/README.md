fetchcontent 的一个缺点（特点）是， 如果引入的工程自身修改了一些全局的设定， 会导致整个工程的结果可能不符合预期。

举例来说， 现在要做一个矩阵计算的库， 默认的 bin、 lib 输出路径应该是各自源码所在目录。

但如果通过 fetchcontent 引入了 jsoncpp 工程， 这个工程的root CMakeLists.txt 重写了如下几个变量：
```cmake
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib" CACHE PATH "Archive output dir.")

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib" CACHE PATH "Library output dir.")

set(CMAKE_PDB_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin" CACHE PATH "PDB (MSVC debug symbol) output dir.")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin" CACHE PATH "Executable/dll output dir.")
```

导致的结果：
- root 工程的输出目录被改掉
- 后续通过fetchcontent 引入的工程， 编译输出的目录也被改掉

因此需要做修改：
```cmake
FetchContent_Declare(
    JsonCpp
    GIT_REPOSITORY https://github.com/open-source-parsers/jsoncpp.git
    GIT_TAG 1.9.4
)
FetchContent_MakeAvailable(JsonCpp)

#以下内容是修改
unset(CMAKE_ARCHIVE_OUTPUT_DIRECTORY CACHE)
unset(CMAKE_LIBRARY_OUTPUT_DIRECTORY CACHE)
unset(CMAKE_PDB_OUTPUT_DIRECTORY CACHE)
unset(CMAKE_RUNTIME_OUTPUT_DIRECTORY CACHE)
```