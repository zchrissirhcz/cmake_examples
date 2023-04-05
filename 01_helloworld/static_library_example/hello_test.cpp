#include "hello.h"
#include <stddef.h> // for NULL

int main()
{
    hello(NULL);
    hello("CMake");

    return 0;
}