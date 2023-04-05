// https://www.cnblogs.com/zjutzz/p/12565754.html

#include <iostream>
#include <cmath>
#include <sstream>
#include <chrono>

//sse2
#if defined _MSC_VER && defined _M_X64 || (defined __GNUC__ && defined __SSE2__&& !defined __APPLE__)
#include <emmintrin.h>
#endif

//sse 4.1
#include <smmintrin.h>


//sse2 optimized
inline int cvCeil(double value)
{
#if defined _MSC_VER && defined _M_X64 || (defined __GNUC__ && defined __SSE2__&& !defined __APPLE__)
    __m128d t = _mm_set_sd( value );
    int i = _mm_cvtsd_si32(t);
    return i + _mm_movemask_pd(_mm_cmplt_sd(_mm_cvtsi32_sd(t,i), t));
#elif defined __GNUC__
    int i = (int)value;
    return i + (i < value);
#else
    int i = cvRound(value);
    float diff = (float)(i - value);
    return i + (diff < 0);
#endif
}


//sse4 optimized
inline int myCeil(double value)
{
#if defined _MSC_VER && defined _M_X64 || (defined __GNUC__ && defined __SSE2__&& !defined __APPLE__)

    /*
    //这段实现，ubuntu上clang-8.0，运行结果正确，但是VS2017运行结果不对。。速度是25ms
    __m128d val = _mm_set_sd(value);
    __m128d dst;
    _mm_round_sd(dst, val, _MM_FROUND_CEIL);
    return _mm_cvtsd_si32(dst);
    */

    //这段实现，ubuntu clang-8.0和VS2017结果都正确，不过慢了一些，70ms左右
    __m128d val = _mm_set_sd(value);
    __m128d res = _mm_round_sd(val, val, _MM_FROUND_CEIL);
    return _mm_cvtsd_si32(res);

#elif defined __GNUC__
    int i = (int)value;
    return i + (i < value);
#else
    int i = cvRound(value);
    float diff = (float)(i - value);
    return i + (diff < 0);
#endif
}



template<typename T, typename P>
std::string toString(std::chrono::duration<T,P> dt)
{
    std::ostringstream str;
    using namespace std::chrono;
    str << duration_cast<microseconds>(dt).count()*1e-3 << " ms";
    return str.str();
}

int main () {
    volatile double x = 34.234;
    volatile double y1, y2, y3;
    const int MAX_ITER=100000000;
    const auto t0 = std::chrono::steady_clock::now();

    for(int i=0; i<MAX_ITER; i++) {
        y1 = std::ceil(x);
    }
    const auto t1 = std::chrono::steady_clock::now();

    for(int i=0; i<MAX_ITER; i++) {
        y2 = cvCeil(x);
    }
    const auto t2 = std::chrono::steady_clock::now();

    for(int i=0; i<MAX_ITER; i++) {
        y3 = myCeil(x);
    }
    const auto t3 = std::chrono::steady_clock::now();



    std::cout << "std::ceil: " << toString(t1-t0) << "\n";
    std::cout << "cvCeil   : " << toString(t2-t1) << "\n";
    std::cout << "myCeil   : " << toString(t3-t2) << "\n";
    std::cout << "y1=" << y1 << ", y2=" << y2 << ", y3=" << y3 << std::endl;

    return 0;
}
