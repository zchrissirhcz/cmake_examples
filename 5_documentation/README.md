# Documentation

Doxygen is perhaps the official C/C++ document generation tool, which generate docs mainly from comments with special marks, and can also generate document pages from markdown files.

When building your C/C++ project, especially during CI/CD, build the doc together is an good option. Calling doxygen can just be integrated into CMake, then you have the experience of :
```bash
cmake -S . -B build
cd build
make -j4
make docs # here
```
