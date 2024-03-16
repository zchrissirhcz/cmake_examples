#include "foo.h"
#include <stdio.h>
#include "hello.h"

int main()
{
    float a = 3.14;
    float b = my_tan(a);
    printf("b = %f\n", b);

    hello("world");

    return 0;
}
