#define BAR(x) ((x) || (x))
template <typename T> void foo(T x) {
  for (unsigned I = 0; I < 10; ++I) { BAR(I); }
}
int main() {
  foo<int>(0);
  foo<float>(0);
  return 0;
}
