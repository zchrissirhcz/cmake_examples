#ifndef DARK_VISION_ALLOC_H
#define DARK_VISION_ALLOC_H

#include <stdio.h>
#include <stdlib.h>

namespace dv{

typedef unsigned char uchar;

void* fastMalloc(size_t bufSize);
void fastFree(void* ptr);

template<typename _Tp> static inline _Tp* alignPtr(_Tp* ptr, int n = (int)sizeof(_Tp))
{
    return (_Tp*)(((size_t)ptr + n - 1) & -n);
}

}

#endif
