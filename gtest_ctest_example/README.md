# gtest_ctest_example

单独讲 gtest 的案例很多， 讲在 CMake 中配置 gtest 依赖的也有一些；
讲 ctest 的不多， 讲 gtest 和 ctest 配合使用的就更少了。

其实很简单， 只需要两步：
```
enable_testing()
gtest_add_tests(TARGET testbed)
```

然后就可以愉快的用 `ctest` 或 `make test` 来执行了！

More info: https://cmake.org/cmake/help/latest/module/GoogleTest.html

Since CMake 3.10

