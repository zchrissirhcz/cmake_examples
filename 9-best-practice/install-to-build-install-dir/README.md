Install to build/install directory, instead of /usr/local (linux) or C:/Program Files (x86)/<project_name>.

```bash
cmake -S . -B build
cmake --build build
cmake --build build --target install
```


```
➜  install-to-build-install-dir git:(main) ✗ tree -L 3 build
build
├── cmake_install.cmake
├── CMakeCache.txt
├── CMakeFiles
├── install # This directory is what we want!
│   ├── inc
│   │   └── hello.h
│   └── lib
│       └── libhello.a
├── install_manifest.txt
├── libhello.a
└── Makefile
```

Ref: https://zhuanlan.zhihu.com/p/1915187417180271016
