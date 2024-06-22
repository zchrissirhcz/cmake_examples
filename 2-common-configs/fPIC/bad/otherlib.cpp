#include "otherlib.h"
#include <stdio.h>

void otherlib()
{
    thread_local int a = 3;
    printf("this is other lib, a = %d\n", a);
}