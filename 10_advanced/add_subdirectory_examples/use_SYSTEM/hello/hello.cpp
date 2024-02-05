#include "hello.h"
#include <stdio.h>

void hello(const char* name)
{
    printf("name is %s\n", name);
    {
        const char* name = "world";
        printf("  hello, %s\n", name);
    }
}