#include <time.h>
#include <stdio.h>

#define LOOP (1e9)
#define OP_FLOATS (80)

void TEST(int);

static double get_time(struct timespec* start, struct timespec* end)
{
    return end->tv_sec - start->tv_sec + (end->tv_nsec - start->tv_nsec) * 1e-9;
}

int main() {
    struct timespec start, end;
    double time_used = 0.0;

    clock_gettime(CLOCK_MONOTONIC_RAW, &start);
    TEST(LOOP);
    clock_gettime(CLOCK_MONOTONIC_RAW, &end);
    time_used = get_time(&start, &end);
    printf("perf: %.6lf \n", LOOP*OP_FLOATS*1.0 * 1e-9 / time_used);

    return 0;
}