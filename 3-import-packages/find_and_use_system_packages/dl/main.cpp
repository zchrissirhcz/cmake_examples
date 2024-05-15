#include <iostream>
#include <dlfcn.h>

int main(int argc, char** argv)
{
    typedef void* (*fptr)();
    fptr func;
    void *handle = dlopen(0, RTLD_NOW);
    std::cout << dlerror() << std::endl;    
    *(void **)(&func) = dlsym(handle, "__libc_start_main");
    std::cout << dlerror() << std::endl;

    std::cout << handle << " " << func << "\n";

    dlclose(handle);
    return 0;
}