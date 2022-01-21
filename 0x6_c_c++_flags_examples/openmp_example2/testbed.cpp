#include <stdio.h>

#include <omp.h>

#include "hello.h"

int main(int argc, char** argv)
{
    omp_set_dynamic(0);
    #pragma omp parallel
    {
        fprintf(stderr, ">>> hello\n");
    }

    hello("ChrisZZ");

    #ifdef _OPENMP
    printf("defined _OPENMP\n");
    #else
    printf("not defined _OPENMP\n");
    #endif

    int a = _OPENMP;

    return 0;
}
