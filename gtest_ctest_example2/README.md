# gtest_ctest_example2

这个例子展示的是， 如果单元测试是通过 `add_subdirectory(tests)` 引入的（tests是目录名字），则需要在这之前调用 `enable_testing()`，来确保 `make test` 可用。

如果只是在 `tests/CMakeLists.txt` 里设置 `enable_testing()` 而没有在 `add_subdirectory()` 前设置， 则依然没有 `make test` 可用。

`ctest` 命令的有效性等于 `make test` 的有效性。
