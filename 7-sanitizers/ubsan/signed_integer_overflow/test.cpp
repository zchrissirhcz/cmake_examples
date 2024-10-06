#include <algorithm>
#include <iostream>
#include <string>

int main()
{
//    int cc = -1323752223;
//    int aa = 1134903170;
//    if (cc < aa)
//    {
//        std::cout << "cc < aa: YES\n";
//    }
//    else
//    {
//        std::cout << "cc < aa: NO\n";
//    }
//
//    return 0;

    int a = 1;
    int b = 1;
    int c = 0;

    std::cout << "i = 1, fibo = " << a << "\n";
    std::cout << "i = 2, fibo = " << b << "\n";
    for (int i = 3; ; i++)
    {
        c = a + b;

        if (c < a)
        {
            std::string msg = "Overflow at i = " + std::to_string(i) + ", c = " + std::to_string(c) + ", a = " + std::to_string(a) + ", b = " + std::to_string(b);
            throw std::runtime_error(msg);
        }

        std::cout << "i = " << i << ", fibo = " << c << ", a = " << a << ", b = " << b << "\n";

        a = b;
        b = c;
    }

    return 0;
}
