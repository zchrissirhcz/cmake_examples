/*
 * Header-only time measurement class
 * Created by Zhuo Zhang (imzhuo@foxmail.com)
 * Last update: 2022-12-04 20:26:00
 *
 * Usage:
 *
 * #include "autotimer.hpp"
 *
 * ...
 *
 * {
 *     AutoTimer timer("my task");
 *     my_task(); // run your task
 * } // automatically calling ~AutoTimer(), which print time cost
 *
 */

#pragma once

#if _WIN32
#ifndef NOMINMAX
#define NOMINMAX
#endif // NOMINMAX
#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif // WIN32_LEAN_AND_MEAN
#include <windows.h>
#else
#include <sys/time.h>
#endif

#include <string>

#define AUTOTIMER_STDIO 1

#if AUTOTIMER_STDIO
#if __ANDROID_API__ >= 8
#include <android/log.h>
#define AUTOTIMER_LOGE(...)                                            \
    do {                                                               \
        fprintf(stderr, ##__VA_ARGS__);                                \
        __android_log_print(ANDROID_LOG_WARN, "plain", ##__VA_ARGS__); \
    } while (0)
#else
#include <stdio.h>
#define AUTOTIMER_LOGE(...)             \
    do {                                \
        fprintf(stderr, ##__VA_ARGS__); \
    } while (0)
#endif
#else
#define AUTOTIMER_LOGE(...)
#endif

/// Return time in milliseconds (10^(-3) seconds)
static inline double getCurrentTime()
{
#ifdef _WIN32
    LARGE_INTEGER freq;
    LARGE_INTEGER pc;
    QueryPerformanceFrequency(&freq);
    QueryPerformanceCounter(&pc);
    return pc.QuadPart * 1000.0 / freq.QuadPart;
#else
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec * 1000.0 + ts.tv_nsec / 1000000.0;
#endif // _WIN32
}

static inline double getElapsedTime(const double startTime)
{
    return getCurrentTime() - startTime;
}

class AutoTimer
{
public:
    explicit AutoTimer(const std::string& name, int loopCount = 1, bool autoReport = true, bool onlyAverage = false)
        : mName(name), mLoopCount(loopCount), mStartTime(getCurrentTime()), mAutoReport(autoReport), mOnlyAverage(onlyAverage), mCurrentStartTime(getCurrentTime()), mPunchCount(0)
    {
    }
    ~AutoTimer()
    {
        if (mAutoReport)
            this->report();
    }

    void report() const
    {
        //std::cout << mName << ": took " << GetElapsed() << " ms" << std::endl;
        if (mOnlyAverage)
        {
            double averageCost = getElapsedTime(mStartTime) / mLoopCount;
            AUTOTIMER_LOGE("%8s: took %7.3lf ms (on average)", mName.c_str(), averageCost);
        }
        else
        {
            double totalCost = getElapsedTime(mStartTime);
            AUTOTIMER_LOGE("%8s: took %7.3lf ms", mName.c_str(), totalCost);
            if (mLoopCount > 1)
            {
                AUTOTIMER_LOGE(", loop=%d, avg = %6.3lf ms", mLoopCount, totalCost / mLoopCount);
            }
        }
        AUTOTIMER_LOGE("\n");
    }

    /// Return time in milliseconds
    double getElapsed() const
    {
        return getElapsedTime(mStartTime);
    }

    double getElapsedAverage() const
    {
        return getElapsedTime(mStartTime) / mLoopCount;
    }

    void reset(int loopCount = 1)
    {
        mStartTime = getCurrentTime();
        mLoopCount = loopCount;
    }

    // record current loops time cost
    void punch()
    {
        if (mPunchCount < maxPunchCount)
        {
            double now = getCurrentTime();
            data[mPunchCount] = now - mCurrentStartTime;
            mCurrentStartTime = now;
            mPunchCount++;
        }
    }

    // print each loop's time cost
    void reportPunches()
    {
        AUTOTIMER_LOGE("    time cost of each:");
        for (int i = 0; i < mPunchCount; i++)
        {
            AUTOTIMER_LOGE(" %5.2lf ms,", data[i]);
        }
        AUTOTIMER_LOGE("\n");
    }

public:
    const static int maxPunchCount = 100;
    double data[maxPunchCount]; // punch data for each loop.

private:
    AutoTimer(const AutoTimer&);
    AutoTimer& operator=(const AutoTimer&);

private:
    std::string mName;
    int mLoopCount;
    double mStartTime;
    bool mAutoReport;
    bool mOnlyAverage;

    double mCurrentStartTime;
    int mPunchCount;
};
