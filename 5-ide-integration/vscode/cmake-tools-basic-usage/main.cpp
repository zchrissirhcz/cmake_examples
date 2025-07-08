#include <stdio.h>
#include <opencv2/opencv.hpp>

int main(int argc, char** argv)
{
    printf("Hello, from hello!\n");
    printf("args:");
    for (int i=0; i<argc; i++)
    {
        printf(" %s", argv[i]);
    }
    printf("\n");

    const std::string image_path = "/Users/zz/data/1920x1080.jpg";
    cv::Mat image = cv::imread(image_path);
    cv::imshow("image", image);
    cv::waitKey(0);

    return 0;
}
