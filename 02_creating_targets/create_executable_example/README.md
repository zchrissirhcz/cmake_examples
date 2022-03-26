# create_executable_example

Creating an executable target is most simple target you can create.

Just write out hello-world in C++ in `main()` function, and describe it CMakeLists.txt:
```cmake
cmake_minimum_required(VERSION 3.20)
project(example)
add_executable(helloworld main.cpp)
```

Build and run it:
```
mkdir build
cd build
cmake ..
cmake --build .
./helloworld
```
