#include <stdio.h>
int main()
{
    printf("hello, cmake presets\n");

    printf("sizeof(int*)=%d\n", sizeof(int*));

    printf("current platform: ");
#if __ANDROID__
    printf("android");
    if (sizeof(int*)==4) {
        printf(" 32 bit\n");
    }
    else {
        printf(" 64 bit\n");
    }
#elif __linux__
    printf("linux\n");
#elif _MSC_VER
    printf("MSVC\n");
#else
    printf("unknown\n");
#endif

    return 0;
}
