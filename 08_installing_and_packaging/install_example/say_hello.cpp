#include "hello.h"
#include <stdio.h>

int main(int argc, char** argv)
{
    if (argc<2)
    {
        hello(NULL);
    }
    else
    {
        hello(argv[1]);
    }

    return 0;
}