#include <benchmark/benchmark.h>
#include <iostream>
using namespace std;

static void BM_StringCreation(benchmark::State& state) {
  for (auto _ : state)
    std::string empty_string;
}
// Register the function as a benchmark
BENCHMARK(BM_StringCreation);

// Define another benchmark
static void BM_StringCopy(benchmark::State& state) {
  std::string x = "hello";
  for (auto _ : state)
    std::string copy(x);
}

BENCHMARK(BM_StringCopy);

static void BM_Hello(benchmark::State& state) // 参数类型必须是 benchmark::State& state
{
    for (auto _ : state) {
        double sum = 0;
        for (int i=0; i<10; i++) {
            sum += i;
        }
        //fprintf(stdout, "sum=%.4lf\n", sum);
        //cout << "sum=" << sum << std::endl;
    }
}
//stderr  BM_Hello               10154 ns         1944 ns       355980
//stdout  BM_Hello               10184 ns         1951 ns       359521
//cout    BM_Hello                9359 ns         2043 ns       337867

BENCHMARK(BM_Hello);

BENCHMARK_MAIN();