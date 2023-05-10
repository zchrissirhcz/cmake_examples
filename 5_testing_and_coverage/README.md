# Testing and Coverage

Writing unittest helps improve software quality. Integrating unittest building with coverage helps you know your test quality well.

The unittest and coverage can be integrated into CMake, then you have the experience of:
```bash
cmake -S . -B build
cd build
make -j4
make test  # here
make coverage # here
```
