#include <stdio.h>
#include <string>
#include <iostream>
#include <memory>
#include <math.h>

int main()
{
    printf("hello\n");
    std::string str = "hello world";
    std::cout << str << std::endl;
    float a;
    scanf("%f", &a);
    double f = acos(1.2);
    volatile float b = sin(a);
    int c = b * 2;
    printf("c=%d\n", c);
    printf("f=%lf\n", f);

    std::shared_ptr<int> p1 = std::make_shared<int>();
    *p1 = 78;
    std::cout << "p1=" << *p1 << std::endl;

    return 0;
}
