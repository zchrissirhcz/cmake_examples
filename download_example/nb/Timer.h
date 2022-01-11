#pragma once
#include <chrono>
#include <ctime>
#include <string>

//计时器类
class Timer
{
private:
    std::chrono::time_point<std::chrono::system_clock> t0_, t1_;
    bool running_ = false;

public:
    Timer() { start(); }

    //以字符串返回当前时间
    static std::string getNowAsString(const std::string format = "%F %a %T")
    {
        auto t = std::chrono::system_clock::now();
        auto time = std::chrono::system_clock::to_time_t(t);
        char buffer[80];
        strftime(buffer, 80, format.c_str(), localtime(&time));
        return buffer;
    }

    void start()
    {
        running_ = true;
        t0_ = std::chrono::system_clock::now();
    }

    void stop()
    {
        running_ = false;
        t1_ = std::chrono::system_clock::now();
    }

    double getElapsedTime(bool restart = false)
    {
        if (running_)
        {
            t1_ = std::chrono::system_clock::now();
        }
        auto s = std::chrono::duration_cast<std::chrono::duration<double>>(t1_ - t0_);
        if (restart)
        {
            t0_ = std::chrono::system_clock::now();
        }
        return s.count();
    }

    double getLastPeriod()
    {
        return getElapsedTime(true);
    }

    static std::string autoFormatTime(double s)
    {
        const int size = 80;
        char buffer[size];
        int h = s / 3600;
        int m = (s - h * 3600) / 60;
        s = s - h * 3600 - m * 60;
        if (h > 0)
        {
            snprintf(buffer, size, "%d:%02d:%05.2f", h, m, s);
        }
        else if (m > 0)
        {
            snprintf(buffer, size, "%d:%05.2f", m, s);
        }
        else
        {
            snprintf(buffer, size, "%.2f s", s);
        }
        return std::string(buffer);
    }

    static int64_t getNanoTime()
    {
        return std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
    }
};