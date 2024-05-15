#pragma once

class AutoLogger
{
public:
    AutoLogger(const char* name)
    {
        printf("-- Begin of %s\n", name);
    }
    ~AutoLogger()
    {
        printf("-- End of %s\n", name);
    }
};