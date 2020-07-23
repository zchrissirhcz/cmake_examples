#include "bottle.h"
#include <time.h>
#include <stdio.h>

long long fibo_expected[100] = { 0 };

static void init()
{
    fibo_expected[0] = 1;
    fibo_expected[1] = 1;
    fibo_expected[2] = 2;
    fibo_expected[3] = 3;
    fibo_expected[4] = 5;
    fibo_expected[5] = 8;

    fibo_expected[44] = 1134903170;
    fibo_expected[45] = 1836311903;
    fibo_expected[46] = 2971215073;
}

static int test_fibo(int n)
{
    long long fibo_res = fibo(n);
    long long diff = fibo_expected[n] - fibo_res;
    if (diff != 0) {
        fprintf(stderr, "%s_%d failed: expected=%lld, get=%lld\n", 
            __FUNCTION__, 
            n,
            fibo_expected[n],
            fibo_res
        );
    }
    return diff;
}

static int test_fibo_0() {
    return test_fibo(0);
}

static int test_fibo_1() {
    return test_fibo(1);
}

static int test_fibo_2() {
    return test_fibo(2);
}

static int test_fibo_3() {
    return test_fibo(3);
}

static int test_fibo_4() {
    return test_fibo(4);
}

static int test_fibo_5() {
    return test_fibo(5);
}

static int test_fibo_44() {
    return test_fibo(44);
}

static int test_fibo_45() {
    return test_fibo(45);
}

static int test_fibo_46() {
    return test_fibo(46);
}


int main()
{
    init();

    return 0
        || test_fibo_0()
        || test_fibo_1()
        || test_fibo_2()
        || test_fibo_3()
        || test_fibo_4()
        || test_fibo_5()
        || test_fibo_44()
        || test_fibo_45()
        || test_fibo_46();
}