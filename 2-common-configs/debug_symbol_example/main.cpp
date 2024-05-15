#include <stdio.h>

int main()
{
    printf("Nice ChrisZZ!\n");

#if __ARM_NEON
    printf("arm neon!\n");
#else
    printf("not arm neon\n");
#endif
     
    int a = 3;
    int b = 4;
    int c = a + b;
    int d = c + 5;
    printf("c = %d\n", c);

    return 0;
}