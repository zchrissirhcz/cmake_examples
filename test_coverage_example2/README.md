# test_coverage_example

CMake with testing coverage integration. Supports both GCC and Clang.

The generated html report is same for both Cland and GCC, since using same compile options, same linking options, same coverage front tool lcov.

```bash
mkdir build
cd build
cmake ..

make
make coverage

cd coverage_report
python -m http.server 7082
```

## References

- http://logan.tw/posts/2015/04/28/check-code-coverage-with-clang-and-lcov/

- https://stackoverflow.com/questions/56258782/when-i-compile-my-code-with-clang-gcov-throws-out-of-memory-error