# clang coverage example

## What is this
In this example, we integrate CMake with Clang compiler for generating test coverage report.

The Clang compiler version is 13.0.0, lower version not tested. It ships with `llvm-cov` command, instead of installing another external tool like `gcov` or `lcov`.

The integration of Clang, llvm-cov and CMake, is quite like GCC, gcov, lcov and CMake.

## Preparation
Installing Clang 13.0.0. My clang is compiled from source with:
```bash
#!/bin/bash

cmake .. \
    -G Ninja \
    -D LLVM_ENABLE_PROJECTS='clang;libcxx;libcxxabi;libunwind;lldb;compiler-rt;lld;polly;openmp' \
    -D CMAKE_BUILD_TYPE=Release \
    -D LLVM_TARGETS_TO_BUILD='X86' \
    -D CMAKE_INSTALL_PREFIX=~/soft/llvm13 \
    -D CMAKE_C_COMPILER=clang \
    -D CMAKE_CXX_COMPILER=clang++ \
    -D LIBCXX_CXX_ABI=libcxxabi \
    ../llvm

```

### Play
```
mkdir build
cd build
cmake ..
make
make coverage
```

## References

https://clang.llvm.org/docs/SourceBasedCodeCoverage.html

https://llvm.org/docs/CommandGuide/llvm-cov.html