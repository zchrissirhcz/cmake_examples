#pragma once

#include <stdio.h>

class AutoLogger
{
public:
    AutoLogger(const char* name):
        m_name(name)
    {
        printf("%s begin\n", m_name);
    }
    ~AutoLogger()
    {
        printf("%s end\n", m_name);
    }
private:
    const char* m_name;
};