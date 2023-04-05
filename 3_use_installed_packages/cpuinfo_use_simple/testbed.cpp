#include <stdio.h>
#include "cpuinfo.h"

int main()
{
    cpuinfo_initialize();

    const cpuinfo_core* core = cpuinfo_get_current_core();
    printf("core is %p\n", core);

    cpuinfo_deinitialize();

    return 0;
}

