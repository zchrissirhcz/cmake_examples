#include "autotimer.hpp"

int main()
{
    {
        AutoTimer timer("timer");
        double sum = 0;
        for (int i = 0; i < 10000; i++)
        {
            sum += i;
        }
        printf("sum = %lf\n", sum);
    }

    return 0;
}