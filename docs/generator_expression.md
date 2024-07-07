# generator expression 生成器表达式

## 概要

build system generation 阶段起作用。相当于说， CMakeLists.txt 里是类似 C++ 中 template 的写法， 此时打印生成器表达式得到的仍然是表达式本身的形式， 而非取值； 而在生成的 Makefile/build.ninja 里，则替换为具体的取值.

两种形式:
- `$<变量>`, 相当于 `${变量}`, 例如 `$<CXX_COMPILER_ID>`
- `$<条件:值>`, 当条件为1时结果为冒号后的值，当条件为0时取值为0
    - “条件” 和 “值”， 可以是变量
    - “条件” 和 “值”， 也可以是 generator expression （嵌套情况）

```cmake
add_executable(x x.c)
target_include_directories(x PRIVATE /opt/include/$<CXX_COMPILER_ID>)
get_target_property(result x INCLUDE_DIRECTORIES)
message(STATUS "result: ${result}") # 打印出 /opt/include/$<CXX_COMPILER_ID>
```
在 build/x.dir/flags.make 中显示 `C_INCLUDES=-I/opt/include/GNU`
在 build/build.ninja 中显示
```
build CMakeFiles/x.dir/x.c.o: ...
INCLUDES = -I/opt/include/GNU
```

一个常见报错，关于头文件包含目录的:
```
-- Configuring done (0.0s)
CMake Error in MathFunctions/CMakeLists.txt:
  Target "MathFunctions" INTERFACE_INCLUDE_DIRECTORIES property contains
  path:

    "C:/work/Tutorial/MathFunctions"

  which is prefixed in the source directory.
```
原因是指定的 INTERFACE 传递方式下的头文件目录，包含了源码目录， 这对于`install()`命令中指定了 `EXPORT <export-name>` 的情况， 是硬编码了本地路径，需要改为 install/export 时候的头文件包含路径，例如：
```
target_include_directories(MathFunctions 
  INTERFACE 
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:include>
)
```


## `BUILD_INTERFACE` and `INSTALL_INTERFACE`

```cmake
add_library(hello STATIC hello.c)
target_include_directories(hello PUBLIC 
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
)
```

## CONFIG

Actual `CMAKE_BUILD_TYPE`.
