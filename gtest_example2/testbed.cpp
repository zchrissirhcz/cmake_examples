#include <stdio.h>

#include <opencv2/opencv.hpp>
#include <gtest/gtest.h>

#include <string>

void test_imread()
{
    std::string image_path = "hello.jpg";
    cv::Mat image = cv::imread(image_path);

    EXPECT_TRUE(image.empty()==false);
}


int main(int argc, char* argv[])
{
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}