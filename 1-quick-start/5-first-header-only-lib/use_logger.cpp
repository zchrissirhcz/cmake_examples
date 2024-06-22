#include "logger.hpp"

int main()
{
    {
        AutoLogger logger("main");
    }
    
    return 0;
}