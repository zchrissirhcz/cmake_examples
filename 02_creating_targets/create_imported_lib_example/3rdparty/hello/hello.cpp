#include "hello.hpp"
#include <iostream>

void hello(const char *name)
{
    if (name)
    {
        std::cout << "Hello, " << name << std::endl;
    }
    else
    {
        std::cout << "Hello, World!" << std::endl;
    }
}