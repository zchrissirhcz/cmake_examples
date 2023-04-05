#include <iostream>
#include <typeinfo>

void hello(const std::string& name)
{
    std::cout << "Hello, " << name << std::endl;
}

int main()
{
    int data = 233;
    //auto a = hello;
    auto a = data;

    std::cout << typeid(a) << std::endl;
    return 0;
}