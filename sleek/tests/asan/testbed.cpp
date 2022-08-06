#include <stdio.h>
#include <stdlib.h>

int main()
{
    const int n = 1024;
    int* data = (int*)malloc(sizeof(int)*n);
    data[2048] = 233;
    printf("data[2000]=%d, data[2048]=%d\n", data[2000], data[2048]);

    return 0;
}