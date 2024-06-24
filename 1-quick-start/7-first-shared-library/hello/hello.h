#pragma once

#ifdef HELLO_EXPORT_SYMBOLS
#   if (defined _WIN32 || defined WINCE || defined __CYGWIN__)
#       define HELLO_API __declspec(dllexport)
#   elif defined __GNUC__ && __GNUC__ >= 4
#       define HELLO_API __attribute__ ((visibility ("default")))
#   endif
#else
#   define HELLO_API
#endif

HELLO_API void hello_init();
HELLO_API void hello_destroy();
HELLO_API void hello_run(const char* name);
