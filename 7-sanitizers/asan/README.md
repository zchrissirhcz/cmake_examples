# Address Sanitizer

| task                          | Linux-x64 | macOS-arm64 | Windows-x64 |
| ----------------------------- | --------- | ----------- | ----------- |
| Run OpenCL                    | Support   | ?           | ?           |
| Detect Memory Leak            | Support   | Not support | Not support |
| Detect Heap Buffer Overflow   | Support   | Support     | Support     |

If some module is using OpenCL and not compiled with ASAN, set envvar before running:
```bash
export ASAN_OPTIONS=protect_shadow_gap=0
./test
```

In GDB if `no stack` reported, set a breakpoint which shows backtrace info:
```bash
(gdb) break __sanitizer::Die
```
