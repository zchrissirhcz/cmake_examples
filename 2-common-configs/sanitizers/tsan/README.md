# Thread Sanitizer Example

## Intro
This example is based on the example code from [tsan official wiki](https://github.com/google/sanitizers/wiki/ThreadSanitizerCppManual), with modification for more easy to reproduce and resolve multithread data race bug.

Currently this demo only works on Linux due to use of `pthread` instead of `std::thread`.

## Usage
```cmake
mkdir build
cd build
cmake .. -DUSE_TSAN=ON -DCMAKE_BUILD_TYPE=Debug
cmake --build .
cd ..
```

**testbed.cpp, the data race one**

```
==================
WARNING: ThreadSanitizer: data race (pid=193294)
  Write of size 4 at 0x0000038eae08 by thread T2:
    #0 Thread2(void*) /home/zz/work/cmake_examples/thread_sanitizer_example/testbed.cpp:12:11 (testbed+0x4d7788)

  Previous write of size 4 at 0x0000038eae08 by thread T1:
    #0 Thread1(void*) /home/zz/work/cmake_examples/thread_sanitizer_example/testbed.cpp:7:11 (testbed+0x4d7738)

  Location is global 'Global' of size 4 at 0x0000038eae08 (testbed+0x38eae08)

  Thread T2 (tid=193297, running) created by main thread at:
    #0 pthread_create <null> (testbed+0x44f22d)
    #1 main /home/zz/work/cmake_examples/thread_sanitizer_example/testbed.cpp:19:5 (testbed+0x4d77de)

  Thread T1 (tid=193296, finished) created by main thread at:
    #0 pthread_create <null> (testbed+0x44f22d)
    #1 main /home/zz/work/cmake_examples/thread_sanitizer_example/testbed.cpp:18:5 (testbed+0x4d77c9)

SUMMARY: ThreadSanitizer: data race /home/zz/work/cmake_examples/thread_sanitizer_example/testbed.cpp:12:11 in Thread2(void*)
==================
ThreadSanitizer: reported 1 warnings
```

**testbed2.cpp, resolved the data race bug**

```
# no any output, "no news is good news"
```

View and edit CMakeLists.txt for play!