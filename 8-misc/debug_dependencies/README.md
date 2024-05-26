## 1. debug.cmake
[debug.cmake](debug.cmake) 提供了两大类功能：
1. 获取某个目标（target）或全局的属性。
2. 获取所有目标（targets)，包括手动创建的、find_package等方式引入的。

具体用法和效果见 [debug_examples](debug_examples) .

## 2. CMAKE_TRACE_MODE
To determine which FindXXX.cmake is used:
```
-DCMAKE_TRACE_MODE=ON
```

