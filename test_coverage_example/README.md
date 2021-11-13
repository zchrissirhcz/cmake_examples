# test_coverage_example

CMake with testing coverage integration. Supports both GCC and Clang.

```
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