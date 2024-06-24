#include "hello.h"
#include <stdio.h>

void hello(const char* name)
{
    if (name==NULL) {
        printf("hello world\n");
    } else {
        printf("hello %s\n", name);
    }
}
