#ifndef HELLO_H
#define HELLO_H

#include <iostream>
#include <string>

__declspec(dllexport) void hello(const char* name);
__declspec(dllexport) std::string get_hello_version();

#endif