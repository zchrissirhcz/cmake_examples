#include <iostream>
#include "hello_config.h"

int main(int argc, char** argv)
{
    std::cout << "hello cmake tutorial" << std::endl;
    std::cout << argv[0] << " Version: " << HELLO_VERSION_MAJOR << "." << HELLO_VERSION_MINOR << std::endl;

    return 0;
}
