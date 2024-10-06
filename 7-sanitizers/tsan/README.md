# Thread Sanitizer

| type        | macOS-arm64    | Linux x64 | Android arm64 | Windows |
| ----------- | -------------- | --------- | ------------- | ------- |
| data race   | Support        | Support   | Support       | N/A     |
| thread leak | Not support    | Support   | Support       | N/A     |

If some modules are not compiled with tsan enable, run the executable with env setup:
```bash
TSAN_OPTIONS=ignore_noninstrumented_modules=1
./test
```
