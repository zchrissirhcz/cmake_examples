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

**Windows host**:
```
set ANDROID_NDK=d:/soft/Android/ndk-r22
set addr2line=%ANDROID_NDK%/toolchains/llvm/prebuilt/windows-x86_64/bin/aarch64-linux-android-addr2line.exe
%addr2line% 0x23870 -C -f -e android-arm64/testbed
```

**Linux host**
```
export ANDROID_NDK=/home/zz/soft/android-ndk-r21b
addr2line=$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android-addr2line
$addr2line 0x23870 -C -f -e android-arm64/testbed
```

- `addr2line` may still print `?` even if linking to `c++_static` library
- testbed can be: executable or shared lib

**addr2line.py**

For debugging android ndk crashes with ASan, people may refer to [addr2line.py](addr2line.py) for parsing example.

## Disable LeakSanitizer
On Linux and macOS, `-fsanitize=address` will automatically enable LeakSanitizer.

This will be annoying sometimes, say, in gdb/lldb debugging: no leak happed, but ASan die.

To solve this:
```bash
export ASAN_OPTIONS=detect_leaks=0
```

ref: [How to suppress LeakSanitizer report when running under -fsanitize=address?](https://stackoverflow.com/questions/51060801/how-to-suppress-leaksanitizer-report-when-running-under-fsanitize-address)

## Is debug mode required?
Take this example code:
```c++
#include <stdio.h>

int main(){
    int a[10];
    a[10] = 233;
    printf("a[10]=%d\n", a[10]);

    return 0;
}
```

Clang 12.0.0 linux x64 compiler, with compile options `-g -O1` generates:
```asm
main:                                   # @main
        push    rax
        mov     edi, offset .L.str
        xor     eax, eax
        call    printf
        xor     eax, eax
        pop     rcx
        ret
.L.str:
        .asciz  "a[10]=%d\n"
```
Which actually prints garbage value when running.

With same compile options and code,  x86-64 gcc 11.1 generates
```asm
.LC0:
        .string "a[10]=%d\n"
main:
        sub     rsp, 8
        mov     esi, 233
        mov     edi, OFFSET FLAT:.LC0
        mov     eax, 0
        call    printf
        mov     eax, 0
        add     rsp, 8
        ret
```
Which actually prints the expected value(233) when running.


This demonstrates one thing: compile optimization may be wrong, thus make it unsuitable with Address Sanitizer.

So, **always use ASan in debug mode first!**.