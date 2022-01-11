#include "nb/Timer.h"

int main()
{
    Timer timer;
    double sum = 0;
    for (int i = 0; i <10000; i++)
    {
        sum += i;
    }
    printf("sum = %lf\n", sum);

    double cost = timer.getElapsedTime();
    printf("time cost is %lf\n", cost);

    return 0;
}
