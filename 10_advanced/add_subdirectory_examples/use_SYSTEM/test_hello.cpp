#include "hello.h"

int main()
{
    const char* name = "world";
    hello("world");
    {
        // const char* name = "cmake";
        // hello(name);
    }
    return 0;
}