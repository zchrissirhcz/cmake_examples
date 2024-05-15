#include <assert.h>
#include <stdio.h>

void print_arch()
{
#if __SSE4_1__
  printf(">>> have __SSE4_1__\n");
#endif

#if __SSE4_2__
  printf(">>> have __SSE4_2__\n");
#endif

#if __POPCNT__
  printf(">>> have __POPCNT__\n");
#endif

#if __AVX__
  printf(">>> have __AVX__\n");
#endif

#if __AVX2__
  printf(">>> have __AVX2__\n");
#endif
}

__attribute__ ((target ("default")))
int foo ()
{
  printf("The default version of foo.\n");
  return 0;
}

__attribute__ ((target ("sse4.1")))
int foo ()
{
  printf("foo version for SSE4.1, implemented\n");
  return 1;
}

__attribute__ ((target ("sse4.2")))
int foo ()
{
  printf("foo version for SSE4.2, implemented\n");
  return 1;
}

__attribute__ ((target ("popcnt")))
int foo ()
{
  printf("foo version for popcnt, not implemented, now lets call sse4.2 version\n");
  return 1;
}

__attribute__ ((target ("avx")))
int foo ()
{
  printf("foo version for AVX\n");
  return 1;
}

__attribute__ ((target ("avx2")))
int foo ()
{
  printf("foo version for avx2, not implemented, now lets call sse4.2 version\n");
  return 1;
}

__attribute__ ((target ("arch=atom")))
int foo ()
{
  printf("foo version for the Intel ATOM processor\n");
  return 2;
}

__attribute__ ((target ("arch=amdfam10")))
int foo ()
{
  printf("foo version for the AMD Family 0x10 processors.\n");
  return 3;
}

int main ()
{
  // int (*p)() = &foo;
  // assert ((*p) () == foo ());

  foo();

  print_arch();

  return 0;
}
