#include <stdio.h>
#include <iostream>
#include <string>

#include <opencv2/opencv.hpp>

int main() {
    std::string im_pth = "lena.jpg";
    cv::Mat im = cv::imread(im_pth);

    if(im.empty()) {
        fprintf(stderr, "Error! file %s not exist\n", im_pth.c_str());
        return -1;
    }

    cv::imshow("image", im);
    cv::waitKey(0);

    return 0;
}
