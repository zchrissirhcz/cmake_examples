#include <iostream>

int main()
{
#ifdef ENABLE_LOGGING
    std::cout << "hello world" << std::endl;
#else
    std::cout << "no logging..." << std::endl;
#endif
    return 0;
}
