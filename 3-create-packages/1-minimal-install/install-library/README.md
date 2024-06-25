Install two files
- `build/install/lib/libhello.a`
- `build/install/include/hello.h`

by these commands:
```bash
cmake -S . -B build
cmake --build build --target install
```