#include <iostream>

#include "hello.h"

int main() {
    std::cout << get_hello_version() << std::endl;
    hello(NULL);
    hello("Zhuo");

    return 0;
}