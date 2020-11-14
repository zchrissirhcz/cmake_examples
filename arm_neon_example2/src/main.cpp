// https://github.com/dawidborycki/NeonIntrinsics-Android/blob/master/app/src/main/cpp/native-lib.cpp

#include <iostream>
#include <string>
#include <arm_neon.h>
#include <chrono>
#include <stdlib.h>
#include "fastMalloc.h"

using namespace std;

short* generateRamp(short startValue, int len) {
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

int dotProduct(short* vector1, short* vector2, int len) {
    int result = 0;

    for(int i = 0; i < len; i++) {
        result += vector1[i] * vector2[i];
    }

    return result;
}

int dotProductNeon(short* vector1, short* vector2, int len) {
    const int transferSize = 4;
    int segments = len / transferSize;
    int remain = len - (segments/4*4)*4;

    // 4-element vector of zeros
    int32x4_t partialSumsNeon = vdupq_n_s32(0);
    int32x4_t sum1 = vdupq_n_s32(0);
    int32x4_t sum2 = vdupq_n_s32(0);
    int32x4_t sum3 = vdupq_n_s32(0);
    int32x4_t sum4 = vdupq_n_s32(0);

    // Main loop (note that loop index goes through segments). Unroll with 4
    int i;
    // sometimes we may do preload
    asm volatile("prfm pldl1keep, [%0, #256]" : :"r"(vector1) :);
    asm volatile("prfm pldl1keep, [%0, #256]" : :"r"(vector2) :);
    for(i=0; i+3 < segments; i+=4) {
        // Load vector elements to registers
        int16x8_t v11 = vld1q_s16(vector1);
        int16x4_t v11_low = vget_low_s16(v11);
        int16x4_t v11_high = vget_high_s16(v11);

        int16x8_t v12 = vld1q_s16(vector2);
        int16x4_t v12_low = vget_low_s16(v12);
        int16x4_t v12_high = vget_high_s16(v12);

        int16x8_t v21 = vld1q_s16(vector1+8);
        int16x4_t v21_low = vget_low_s16(v21);
        int16x4_t v21_high = vget_high_s16(v21);

        int16x8_t v22 = vld1q_s16(vector2+8);
        int16x4_t v22_low = vget_low_s16(v22);
        int16x4_t v22_high = vget_high_s16(v22);

        sum1 = vmlal_s16(sum1, v11_low, v12_low);
        sum2 = vmlal_s16(sum2, v11_high, v12_high);
        sum3 = vmlal_s16(sum3, v21_low, v22_low);
        sum4 = vmlal_s16(sum4, v21_high, v22_high);

        vector1 += 16;
        vector2 += 16;

        // Multiply and accumulate: partialSumsNeon += vector1Neon * vector2Neon
    }
    partialSumsNeon = sum1 + sum2 + sum3 + sum4;

    for(i=0; i<remain; i++) {
        
        int16x4_t vector1Neon = vld1_s16(vector1);
        int16x4_t vector2Neon = vld1_s16(vector2);
        partialSumsNeon = vmlal_s16(partialSumsNeon, vector1Neon, vector2Neon);

        vector1 += 4;
        vector2 += 4;
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
    const int rampLength = 11484;
    const int trials = 1000;

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
    dv::fastFree(ramp1);
    dv::fastFree(ramp2);

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