/*
 * OpenMP example, modified from
 * https://blog.csdn.net/lanbing510/article/details/17108451
 */

#include <iostream>
#include <ctime>
#include <omp.h>

void test()
{
    int a = 0;
    for(int i=0; i<100000000; i++) {
        a++;
    }
}

int bench_omp()
{
    clock_t t1 = clock();
#pragma omp parallel for
    for(int i=0; i<800000; i++)
    {
        test();
    }
    clock_t t2 = clock();
    double time_cost = double(t2-t1)/CLOCKS_PER_SEC;
    printf("bench, with    openmp, time cost %.6lf ms\n", time_cost);

    return 0;
}

int bench()
{
    clock_t t1 = clock();
    for(int i=0; i<8; i++)
    {
        test();
    }
    clock_t t2 = clock();
    double time_cost = double(t2-t1)/CLOCKS_PER_SEC;
    printf("bench, without openmp, time cost %.6lf ms\n", time_cost);

    return 0;
}

int main() {
    omp_set_num_threads(4);
    printf("First ensure you're in release mode\n");
    bench();
    bench_omp();

    return 0;
}
