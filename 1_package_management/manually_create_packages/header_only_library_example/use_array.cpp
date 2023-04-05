#include "array.hpp"

int main()
{
    Array<int> a(10);
    a.fill(1);
    
    Array<int> b(5);
    b.fill(2);

    Array<int> c = a + b;

    std::cout << "a:    " << a << std::endl;
    std::cout << "b:    " << b << std::endl;
    std::cout << "a+b:  " << c << std::endl;

    return 0;
}