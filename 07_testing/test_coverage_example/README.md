# test_coverage_example

CMake with testing coverage integration. Supports both GCC and Clang.

```bash
mkdir build
cd build
cmake ..

make
make coverage

cd coverage_report
python -m http.server 7082
```

## Screenshots
![](coverage1.png)

![](coverage2.png)

## Note

llvm-cov 命令的缺点是， 只能处理单个可执行程序的覆盖率，不能像 lcov 一样直接处理一整个目录的所有测试单元测试文件。

更好的做法见 test_coverage_example2 目录
