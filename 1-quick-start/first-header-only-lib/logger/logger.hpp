#pragma once

#include <stdio.h>

class AutoLogger
{
public:
    AutoLogger(const char* name):
        name(name)
    {
        printf("-- Begin of %s\n", name);
    }
    ~AutoLogger()
    {
        printf("-- End of %s\n", name);
    }
private:
    const char* name;
};