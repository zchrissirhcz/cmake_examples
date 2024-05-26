#include <stdio.h>
#include <opencv2/opencv.hpp>

int main()
{
    cv::Mat mat(10, 20, CV_8UC3);
    printf("mat's dim: height=%d, widht=%d, channels=%d\n",
            mat.rows, mat.cols, mat.channels());

    return 0;
}
