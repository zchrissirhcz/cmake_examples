#include "hello.h"
#include <stdio.h>
#include <stdarg.h>

void print(const char* msg, ...)
{
    va_list args;
    va_start(args, msg);
    vprintf(msg, args);
    va_end(args);
    printf("\n");
}

void hello_init()
{
    print("hello_init() ok");
}

void hello_destroy()
{
    print("hello_destroy() ok");
}

void hello_run(const char* name)
{
    print("hello, %s!", name);
}
