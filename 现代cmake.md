个人粗浅理解的 modern cmake，只要会如下几条命令即可。

## 0x0 创建目标

```
add_executable(testbed xxx.cpp) # 可执行目标； 很常用
add_library(some_lib xxx.cpp) # 默认静态库；不建议这么写
add_library(some_lib STATIC xxx.cpp) # 静态库目标；很常用；
add_library(some_lib SHARED xxx.cpp) # 动态库目标； 还需要考虑C/C++ API的符号导出；暂时不怎么用
```
还有 定制目标（暂时不会）

## 0x1 给目标指明头文件查找目录
```
target_link_libraries(some_target PUBLIC some_include_dir)
```

PUBLIC可以视情况换成PRIVATE/INTERFACE。

不要用 `include_directories()`， 它污染了全局。

## 0x2 给目标指明依赖库
```
target_link_libraries(some_target PUBLIC some_lib)
```

PUBLIC可以视情况换成PRIVATE/INTERFACE。

不要用 `link_libraries()`， 它污染了全局。

`some_lib` 用全局路径， 或者前面创建的（静态或动态库）target， 或者是 find_package / find_library 找到的包， 或者是导入库（imported）。

不要用 `link_directories()` + 不带路径只有文件名的库的形式； 一方面污染全局， 另一方面如果两个路径下有同名的库，选择哪个库（尤其是跨平台编译时）是不确定的。

## 0x3 创建库目标时，指明公共头文件
```
set_target_properties(foo PROPERTIES
    PUBLIC_HEADER
        foo.h
)
```
好处：使用 `install(TARGETS foo)` 时把库文件和公共头文件都拷贝过去了。

## 0x4 给target指定C++标准
```
set_target_properties(joinMap
    PROPERTIES
    CXX_STANDARD 17
)
```

## 0x5 给target指定宏定义
```
target_compile_definitions(testbed PRIVATE P2P_API) #定义 P2P_API 为 1
target_compile_definitions(testbed PRIVATE -DP2P_API) # 定义 P2P_API 为 1
target_compile_definitions(testbed PRIVATE -DP2P_API=233) # 定义 P2P_API 为 233
```

不要用 `add_definitions()`， 那会污染全局。
