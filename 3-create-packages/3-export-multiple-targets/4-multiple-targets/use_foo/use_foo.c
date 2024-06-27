#include <foo/hello.h>
#include <foo/add.h>
#include <stdio.h>

int main()
{
    hello("World");
    hello("CMake");
    
    int a = 1;
    int b = 2;
    int c = add(a, b);
    printf("%d + %d = %d\n", a, b, c);

    return 0;
}
