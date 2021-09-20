#include <stdio.h>
#include <stdlib.h>

void test(int count)
{
    int i;
    for (i=1; i<count; i++)
    {
        if (i%3==0)
        {
            printf("%d is divisible by 3\n", i);
        }
        if (i%11==0)
        {
            printf("%d is divisible by 11\n", i);
        }
        if (i%13==0)
        {
            printf("%d is divisible by 13\n", i);
        }
    }
}

int main(int argc, char** argv)
{
    test(atoi(argv[1]));
    return 0;
}

