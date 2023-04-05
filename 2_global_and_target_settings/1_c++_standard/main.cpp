#include <stdio.h>
#include <vector>

int main()
{
    std::vector<int> v = { 1, 2, 3 };
    for (auto a : v)
    {
        printf("%d, ", a);
    }
    printf("\n");
    return 0;
}