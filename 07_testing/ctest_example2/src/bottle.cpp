#include "bottle.h"

long long fibo(int n)
{
    int a = 1; //fibo(0) = 1
    int b = 1; //fibo(1) = 1
    
    if (n == 0) {
        return a;
    }
    if (n == 1) {
        return b;
    }

    int c;
    for (int i = 2; i <= n; i++) {
        c = a + b;
        a = b;
        b = c;
    }
    return c;
}