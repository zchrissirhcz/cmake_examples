#include <opencv2/opencv.hpp>

int main()
{
    cv::Mat image(cv::Size(256, 256), CV_8UC3);
    for (int i = 0; i < image.rows; i++)
    {
        for (int j = 0; j < image.cols; j++)
        {
            image.ptr(i, j)[0] = i;
            image.ptr(i, j)[1] = j;
            image.ptr(i, j)[2] = (i + j) / 2;
        }
    }
    cv::imwrite("result.png", image);

    return 0;
}