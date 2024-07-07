#include "hello.h"
#include "foo.h"
#include <stdio.h>
#include <string.h>

void hello(const char* name)
{
  const int a = strlen(name);
  float b = 0;
  if (a > 1)
  {
    b = my_tan(a);
  }
  else
  {
    b = a;
  }
  printf("b = %f\n", b);
}