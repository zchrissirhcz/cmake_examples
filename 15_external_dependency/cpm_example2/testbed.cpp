#include <stdio.h>
#include <opencv2/opencv.hpp>

int main(int argc, char* argv[])
{
    cv::Mat mat;
    printf("mat.dims: height=%d, width=%d\n", mat.rows, mat.cols);

    return 0;
}
