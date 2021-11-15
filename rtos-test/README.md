A simple project that verifies the "so called RTOS" compiler toolchains can compile and linking C math library(cos, sin) and C++ (string, shared_ptr).

export PATH:
for arm-none-eabi:
- /home/zz/soft/gcc-arm-none-eabi-4_9-2015q1/bin
    setup nosys

- /home/zz/soft/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-elf
    manually specify -march=armv7-a

for linaro-7.2.1-aarch64:
- /home/zz/soft/gcc-arm-none-eabi-4_9-2015q1/bin
