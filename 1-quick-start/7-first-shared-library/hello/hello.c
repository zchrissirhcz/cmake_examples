#include "hello.h"
#include <stdio.h>

void hello_init()
{
    printf("hello_init() ok\n");
}

void hello_destroy()
{
    printf("hello_destroy() ok\n");
}

void hello_run(const char* name)
{
    printf("hello, %s!\n", name);
}
