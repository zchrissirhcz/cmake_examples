# Bindings and Documentation
## Bindings

The C/C++ language can just be binding to different languages. i.e. write the core algorithm in C/C++, encapsulate it with Python / Matlab / CSharp languages for easy using.

When finding corresponding languages' develepment packages, you may just refer to examples in this directory.

## Documentation

Doxygen is perhaps the official C/C++ document generation tool, which generate docs mainly from comments with special marks, and can also generate document pages from markdown files.

When building your C/C++ project, especially during CI/CD, build the doc together is an good option. Calling doxygen can just be integrated into CMake, then you have the experience of :
```bash
cmake -S . -B build
cd build
make -j4
make docs # here
```
