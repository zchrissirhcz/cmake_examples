#include <stdio.h>

#ifdef USE_ASSEMBLY
extern "C" int CalcSum_(int a, int b, int c);
#else
int CalcSumTest(int a, int b, int c)
{
    return a + b + c;
}
#endif

int main() {
    int a = 17, b = 11, c = 14;
#ifdef USE_ASSEMBLY
    int sum = CalcSum_(a, b, c);
#else
    int sum = CalcSumTest(a, b, c);
#endif

    printf(" a: %d\n", a);
    printf(" b: %d\n", b);
    printf(" c: %d\n", c);
    printf(" sum: %d\n", sum);

    return 0;
}

