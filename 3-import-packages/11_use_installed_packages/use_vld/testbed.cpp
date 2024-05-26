#include <stdio.h>
#include <vld.h>
#include <stdlib.h>
#include <string.h>

int main()
{
    printf("Hello, World!\n");

    const int len = 100;
    int* data = (int*)malloc(sizeof(int) * len);
    return 0;
}

