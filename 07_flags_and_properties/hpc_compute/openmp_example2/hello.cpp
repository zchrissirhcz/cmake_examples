#include "hello.h"
#include <stdio.h>
#include <omp.h>

void hello(const char* name)
{
    if (name)
    {
        fprintf(stderr, "hello, %s\n", name);
    }
    else
    {
        fprintf(stderr, "hello, world\n");
    }

    omp_set_dynamic(0);
    #pragma omp parallel
    {
        fprintf(stderr, ">>>!!!! hello\n");
    }
}