People may use AddressSanitizer for:
- memory leak detection
    - on linux, clang3.8 does not support this. Just pick clang-8 or newer
    - on VS2019 16.8, it still not support this
- invalid memory access detection
    - vs2019 16.8 also support this


More examples for Google Sanitizers' can be found here:
https://github.com/gusenov/examples-google-sanitizers

For Androd platform, NDK's address sanitizer is stll not that good:
- `addr2line` is required, otherwise you won't know which line of code cause segfault, like this;
```
set ANDROID_NDK=d:/soft/Android/ndk-r22
set addr2line=%ANDROID_NDK%/toolchains/llvm/prebuilt/windows-x86_64/bin/aarch64-linux-android-addr2line.exe
%addr2line% 0x23870 -C -f -e android-arm64/testbed
```
- `addr2line` may still print `?` even if linking to c++_static library
- testbed can be: executable or shared lib