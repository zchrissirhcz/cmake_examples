#include <stdio.h>
#include <opencv2/opencv.hpp>
#include <stdlib.h>

int main()
{
    char* path = getenv("PATH");
    printf("PATH: %s\n", path);

    cv::Mat image(256, 256, CV_8UC3);

    cv::imshow("image", image);
    cv::waitKey(0);

    printf("bye~\n");

    return 0;
}