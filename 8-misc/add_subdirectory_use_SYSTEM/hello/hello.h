#pragma once

#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

static inline void test()
{
    const char* name = "test";
    printf("hello, %s\n", name);
    {
        const char* name = "world";
        printf("  hello, %s\n", name);
    }
}

void hello(const char* name);

#ifdef __cplusplus
}
#endif