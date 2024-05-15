#include <stdio.h>

void f1()
{
    int a = 1, b = 2, c = 3;
}

void f2()
{
    int a, b, c;
    printf("%d, %d, %d\n", a, b, c);
}

int main()
{
    f1();
    f2();
    return 0;
}
