# `configure_file` 用法

## 简单理解：
```
configure_file(模板文件  结果文件  [一些乱七八糟的选项])
```

## 作用：

拷贝模板文件为结果文件，并进行替换：
- `@VAR@` 替换为 cmake 运行时的 VAR 变量的值。`${VAR}` 也可以替换，但如无必要请用 `@VAR@` 形式。
- `#cmakedefine VAR ...` 变成 `#define VAR ...`，其中 `...` 可选。
- `#cmakedefine01 VAR` 变成 `#define VAR 0` 或 `#define VAR 1`

## 用法举例：

```
configure_file(foo.h.in foo.h)  # 默认会生成在 CMAKE_CURRENT_BINARY_DIR

target_include_directories(my_target PUBLIC ${CMAKE_CURRENT_BINARY_DIR}) # 可选，但99%时要这么设一下，不然找不到头文件
```

对应代码，则是在 `foo.h.in` 中使用 `@VAR@` 表示 cmake 中的 `VAR` 变量；

在 .h/.cpp 文件中，包含 `foo.h` 来引入宏定义。

## References

https://cmake.org/cmake/help/v3.20/command/configure_file.html
