#include "fastMalloc.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#define DV_MALLOC_ALIGN 16

namespace dv
{
    static void* OutOfMemoryError(size_t size)
    {
        fprintf(stderr, "Failed to allocate %lu bytes", (unsigned long)size);
        return 0;
    }

    void* fastMalloc(size_t size)
    {
        uchar* udata = (uchar*)malloc(size + sizeof(void*) + DV_MALLOC_ALIGN);
        if (!udata)
            return OutOfMemoryError(size);
        uchar** adata = alignPtr((uchar**)udata + 1, DV_MALLOC_ALIGN);
        adata[-1] = udata;
        return adata;
    }

    void fastFree(void* ptr)
    {
        if (ptr)
        {
            uchar* udata = ((uchar**)ptr)[-1];
            assert(udata < (uchar*)ptr &&
                ((uchar*)ptr - udata) <= (ptrdiff_t)(sizeof(void*) + DV_MALLOC_ALIGN));
            free(udata);
        }
    }


}
