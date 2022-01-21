#pragma once

class MyClass
{
public:
  int field;
  virtual void method() const = 0;

  static const int static_field;
  static int static_method();
};

void hello(const char* name);

template<typename T>
void hello(const char* name);