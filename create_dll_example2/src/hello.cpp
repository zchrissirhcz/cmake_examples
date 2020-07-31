#include "hello.h"
#include <stdio.h>

void hello(const char* name)
{
    if (name==NULL) {
        printf("Hello, World!\n");
    } else {
        printf("Hello, %s\n", name);
    }
}

std::string get_hello_version()
{
    std::string s = "0.0.1"; //MAJOR.MINOR.PATCH
    return s;
}
