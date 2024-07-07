// foo.c
#include <stdio.h>
int add1(int);
int main(void) {
    int a, b;
    a = 1;
    b = add1(a); 
    printf("%d+1=%d", a, b);
    return 0;
}
