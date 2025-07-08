#include <stdio.h>
#include <opencv2/opencv.hpp>

int main(int, char**)
{
    printf("Hello, from hello!\n");

    const std::string image_path = "/Users/zz/data/1920x1080.jpg";
    cv::Mat image = cv::imread(image_path);
    cv::imshow("image", image);
    cv::waitKey(0);

    return 0;
}
