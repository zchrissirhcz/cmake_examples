People may use AddressSanitizer for:
- memory leak detection
    - on linux, clang3.8 does not support this. Just pick clang-8 or newer
    - on VS2019 16.8, it still not support this
- invalid memory access detection
    - vs2019 16.8 also support this


More examples for Google Sanitizers' can be found here:
https://github.com/gusenov/examples-google-sanitizers
