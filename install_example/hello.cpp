#include "hello.h"
#include <stdio.h>

void hello(const char* name)
{
    if (name)
    {
        printf("hello, %s\n", name);
    }
    else
    {
        printf("hello, world!\n");
    }
}