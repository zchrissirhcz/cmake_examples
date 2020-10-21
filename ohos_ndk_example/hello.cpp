#include "hello.h"

//#include <stdio>
#include <iostream>

void hello(const char* name)
{
    if (name==NULL) {
        //printf("Hello World\n");
        std::cout << "Hello World\n";
    } else {
        //printf("Hello %s\n", name);
        std::cout << "Hello " << name << "\n";
    }
}