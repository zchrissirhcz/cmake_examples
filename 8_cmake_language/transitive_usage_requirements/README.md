# 依赖库的传递性

## 0. 依赖的传递性
`PRIVATE`, `PUBLIC`, `INTERFACE` 以及 “空”， 被叫做 transitive usage requirements, 是在标记依赖的时候， 标记出依赖的传递性。

最常见是在 `target_link_libraries()` 中使用， e.g.
```cmake
target_link_libraries(foo PUBLIC m)
target_link_libraries(foo PRIVATE m)
target_link_libraries(foo INTERFACE m)
target_link_libraries(foo m)
```

## 1. 依赖的4种传递性， 对于静态库而言没有差别

对于上述例子， 当 `foo` 是静态库时， 上述几种写法等效。 即:
```cmake
add_library(foo STATIC
    foo.h foo.c
)
```

原因是静态库的依赖项会自动传递给依赖了它的下游目标。

## 2. 依赖的4种传递性， 对于可执行文件而言没有差别

两个可执行文件之间， 不存在链接级别的依赖关系。 如果有依赖关系， 那也是同时使用两个 testbed。

因此对于可执行目标， 不必纠结 PUBLIC/PRIVATE/INTERFACE/留空， 因为效果都一样。 最佳实践是写空的。

## 3. 依赖的4种传递性， 对于动态库， 有区别

按照最小 scope 的使用原则， 对于动态库 foo:
- 如果foo库只在实现代码中依赖了某个包 req（头文件+库文件）， 那么标记为 PRIVATE
- 如果foo库只在 API 头文件中依赖了某个包 req，那么标记为 INTERFACE （即: `#include "req.h"`)
    - 此时foo库应当是作为接口库而存在，没有.c/.cpp，只有 .h/.hpp, `add_library(foo INTERFACE foo.h)` 这样
- 如果foo库既在API头文件中、也在实现代码中， 依赖了 req 库的 API, 那么需要标记为 PUBLIC

## 4. 不标记 PUBLIC/INTERFACE/PRIVATE 时， 是怎样的传递属性？

target_link_libraries(foo req)这种写法确实存在,它表示将req库链接到foo目标,但没有明确指定依赖项的传递性。这种情况下,依赖项的传递性由CMake根据目标的类型自动确定:

- 如果foo是一个可执行目标或静态库目标,那么req库将被视为PRIVATE依赖项,不会传递给依赖于foo的其他目标。
- 如果foo是一个动态库目标或接口库目标,那么req库将被视为INTERFACE依赖项,会传递给依赖于foo的其他目标

## 5. 同一个 target 多次标记依赖， 混用传递性： cmake 可能报错

如下写法报错：
```cmake
target_link_libraries(hello foo)
target_link_libraries(hello PUBLIC m)
```

如下写法不报错：
```cmake
target_link_libraries(hello PRIVATE foo)
target_link_libraries(hello PUBLIC m)
```

当写出 `PRIVATE`/`PUBLIC`/`INTERFACE` 时， 叫做 "all-keyword" 写法。
当没有写出这3个关键字里任何一个的时候， 叫做 "all-plain".

cmake 不允许对同一个 target 混用 all-keyword 和 all-plain 的依赖标记， 报错信息是：
```
CMake Error at CMakeLists.txt:15 (target_link_libraries):
  The keyword signature for target_link_libraries has already been used with
  the target "hello".  All uses of target_link_libraries with a target must
  be either all-keyword or all-plain.

  The uses of the keyword signature are here:
```

## 6. 总结：最佳实践

### 静态库
1) 静态库，不用标记依赖库的传递性
```cmake
add_library(foo STATIC foo.c)
target_link_libraries(foo req)
```

2) 静态库，也可以标记依赖库的传递性，但没必要
```cmake
add_library(foo STATIC foo.c)
target_link_libraries(foo PUBLIC req)
# 或 target_link_libraries(foo PRIVATE req)
# 或 target_link_libraries(foo INTERFACE req)
```

3) 静态库， 如果多次标记依赖， 要么都不标记依赖库的传递性， 要么都显式标出传递性
```cmake
target_link_libraries(foo req)
target_link_libraries(foo PUBLIC req2) # 报错
```

```cmake
target_link_libraries(foo PRIVATE req)
target_link_libraries(foo PUBLIC req2) # ok
```

### 动态库
1) 动态库，如果不标记传递性，则等同于 `PUBLIC` 传递性
```cmake
add_library(foo SHARED foo.c)
target_link_libraries(foo req) # 效果等同于target_link_libraries(foo PUBLIC req)
# target_link_libraries(foo PUBLIC req2) # 如果标记另一个库，使用了 PUBLIC 关键字，会报错
```

2) 动态库, 建议手动标明传递性
- 优先用 `PRIVATE`， 意思是只在实现代码中用了依赖库的 API
```cmake
add_library(foo SHARED foo.c)
target_link_libraries(foo PRIVATE req)
```
- 如果在 foo 的 API 头文件中用了 req 的 API， 大概率是多余项， 应当删掉
- 如果确实在 foo 的 API 头文件里要使用 req 的 API
    - 如果只在 foo 的 API 头文件用了 req 的 API， 使用 `INTERFACE`
    ```cmake
    add_library(foo SHARED foo.c)
    target_link_libraries(foo INTERFACE req)
    ```
    - 如果在 foo 的实现代码也用了 req 的 API, 使用 `PUBLIC`
    ```cmake
    add_library(foo SHARED foo.c)
    target_link_libraries(foo PUBLIC req)
    ```

3) 动态库， 如果多次标记依赖， 要么都不标记依赖库的传递性， 要么都显式标出传递性
```cmake
target_link_libraries(foo req)
target_link_libraries(foo PUBLIC req2) # 报错
```

```cmake
target_link_libraries(foo PRIVATE req)
target_link_libraries(foo PUBLIC req2) # ok
```

### 接口库（header-only)
1) 接口库（header-only 库），使用 `INTERFACE` 传递性
```cmake
add_library(foo INTERFACE foo.h)
target_link_libraries(foo INTERFACE req)
```

### 可执行目标
1) 可执行目标， 如果不标记传递性，则等同于 `PUBLIC` 传递性
```cmake
add_executable(foo foo.c)
target_link_libraries(foo req) # 效果等同于 target_link_libraries(foo PUBLIC req)
# target_link_libraries(foo PUBLIC req2) # 如果标记另一个库，使用了 PUBLIC 关键字，会报错
```

2) **可执行目标， 建议不标记传递性**
```cmake
add_executable(foo foo.c)
target_link_libraries(foo req)
```

3) 可执行目标， 如果标记传递性， `PRIVATE`/`PUBLIC` 没差别， 但 `INTERFACE` 会导致链接报错。
```cmake
add_executable(foo foo.c)
target_link_libraries(foo INTERFACE req) # 错误做法：既然foo的实现确实依赖req，那么标记为INTERFACE传递性，会链接报错
```

```cmake
add_executable(foo foo.c)
target_link_libraries(foo PRIVATE req) # 正确, 还行
```

```cmake
add_executable(foo foo.c)
target_link_libraries(foo PRIVATE req) # 正确, 很凑合
```

3) 可执行目标， 如果多次标记依赖， 要么都不标记依赖库的传递性， 要么都显式标出传递性
```cmake
target_link_libraries(foo req)
target_link_libraries(foo PUBLIC req2) # 报错
```

```cmake
target_link_libraries(foo PUBLIC req)
target_link_libraries(foo PUBLIC req2) # ok
```

```cmake
target_link_libraries(foo PUBLIC req)
target_link_libraries(foo PRIVATE req2) # 也 ok，但不太好
```

### 导入库

如果是 prebuilt， 那么创建导入库目标，并且使用 `INTERFACE` 传递性进行标记。

1) 如果 prebuilt 是静态库， 那么务必标注它的依赖：
```cmake
add_library(foo STATIC IMPORTED)
set_target_properties(foo PROPERTIES
  IMPORTED_LOCATION "/path/to/lib/libfoo.a"
  INTERFACE_INCLUDE_DIRECTORIES "/path/to/inc"
)
target_link_libraries(foo INTERFACE req)
```

2) 如果 prebuilt 是动态库， 则根据 API 中是否用了依赖项的 API 来标记：
- 如果 foo 的 API 头文件中没有使用 req 的 API, 那么不标记依赖
- 如果 foo 的 API 头文件中用了 req 的 API， 那么标记依赖
```cmake
add_library(foo SHARED IMPORTED)
set_target_properties(foo PROPERTIES
  IMPORTED_LOCATION "/path/to/lib/libfoo.so"
  INTERFACE_INCLUDE_DIRECTORIES "/path/to/inc"
)
target_link_libraries(foo INTERFACE req)
```