// https://github.com/dawidborycki/NeonIntrinsics-Android/blob/master/app/src/main/cpp/native-lib.cpp

#include <iostream>
#include <string>
#include <arm_neon.h>
#include <chrono>
#include <stdlib.h>
#include "alloc.h"

using namespace std;

short* generateRamp(short startValue, short len) {
    //short* ramp = new short[len];
    short* ramp = (short*)dv::fastMalloc(len);
    for(short i = 0; i < len; i++) {
        ramp[i] = startValue + i;
    }

    return ramp;
}

double msElapsedTime(chrono::system_clock::time_point start) {
    auto end = chrono::system_clock::now();

    return chrono::duration_cast<chrono::milliseconds>(end - start).count();
}

chrono::system_clock::time_point now() {
    return chrono::system_clock::now();
}

int dotProduct(short* vector1, short* vector2, short len) {
    int result = 0;

    for(short i = 0; i < len; i++) {
        result += vector1[i] * vector2[i];
    }

    return result;
}

int dotProductNeon(short* vector1, short* vector2, short len) {
    const short transferSize = 4;
    short segments = len / transferSize;

    // 4-element vector of zeros
    int32x4_t partialSumsNeon = vdupq_n_s32(0);
    int32x4_t sum1 = vdupq_n_s32(0);
    int32x4_t sum2 = vdupq_n_s32(0);
    int32x4_t sum3 = vdupq_n_s32(0);
    int32x4_t sum4 = vdupq_n_s32(0);

    // Main loop (note that loop index goes through segments)
    for(int i = 0; i < segments; i+=4) {
        int16x4_t vector1Neon;
        int16x4_t vector2Neon;

        // Load vector elements to registers
        vector1Neon = vld1_s16(vector1);
        vector1 += 4;
        vector2Neon = vld1_s16(vector2);
        vector2 += 4;
        sum1 = vmlal_s16(sum1, vector1Neon, vector2Neon);

        vector1Neon = vld1_s16(vector1);
        vector1 += 4;
        vector2Neon = vld1_s16(vector2);
        vector2 += 4;
        sum2 = vmlal_s16(sum2, vector1Neon, vector2Neon);

        vector1Neon = vld1_s16(vector1);
        vector1 += 4;
        vector2Neon = vld1_s16(vector2);
        vector2 += 4;
        sum3 = vmlal_s16(sum3, vector1Neon, vector2Neon);

        vector1Neon = vld1_s16(vector1);
        vector1 += 4;
        vector2Neon = vld1_s16(vector2);
        vector2 += 4;
        sum4 = vmlal_s16(sum4, vector1Neon, vector2Neon);

        // Multiply and accumulate: partialSumsNeon += vector1Neon * vector2Neon
        partialSumsNeon = sum1 + sum2 + sum3 + sum4;
    }

    // Store partial sums
    int partialSums[transferSize];
    vst1q_s32(partialSums, partialSumsNeon);

    // Sum up partial sums
    int result = 0;
    for(int i = 0; i < transferSize; i++) {
        result += partialSums[i];
    }

    return result;
}

void test_neon()
{
    // Ramp length and number of trials
    const int rampLength = 1024;
    const int trials = 10000;

    // Generate two input vectors
    // (0, 1, ..., rampLength - 1)
    // (100, 101, ..., 100 + rampLength-1)
    auto ramp1 = generateRamp(0, rampLength);
    auto ramp2 = generateRamp(100, rampLength);

    // Without NEON intrinsics
    // Invoke dotProduct and measure performance
    int lastResult = 0;

    auto start = now();
    for (int i = 0; i < trials; i++) {
        lastResult = dotProduct(ramp1, ramp2, rampLength);
    }
    auto elapsedTime = msElapsedTime(start);

    // With NEON intrinsics
    // Invoke dotProductNeon and measure performance
    int lastResultNeon = 0;

    start = now();
    for (int i = 0; i < trials; i++) {
        lastResultNeon = dotProductNeon(ramp1, ramp2, rampLength);
    }
    auto elapsedTimeNeon = msElapsedTime(start);

    // Clean up
    //delete ramp1, ramp2;

    // Display results
    std::string resultsString =
            "----==== NO NEON ====----\nResult: " + to_string(lastResult)
            + "\nElapsed time: " + to_string((int) elapsedTime) + " ms"
            + "\n\n----==== NEON ====----\n"
            + "Result: " + to_string(lastResultNeon)
            + "\nElapsed time: " + to_string((int) elapsedTimeNeon) + " ms";

    std::cout << resultsString << std::endl;
}
 
int main(int, char*[])
{
    test_neon();

    return 0;
}