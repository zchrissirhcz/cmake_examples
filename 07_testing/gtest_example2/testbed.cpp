#include <stdio.h>

#include <opencv2/opencv.hpp>
#include <gtest/gtest.h>

#include <string>

TEST(OpenCV, read_image)
{
    std::string image_path = "hello.jpg";
    cv::Mat image = cv::imread(image_path);

    EXPECT_TRUE(image.empty()==false);
}

TEST(OpenCV, cvtColor)
{
    std::string image_path = "hello.jpg";
    cv::Mat bgr = cv::imread(image_path);
    ASSERT_TRUE(!bgr.empty());

    cv::Mat gray;
    cv::cvtColor(bgr, gray, cv::COLOR_BGR2GRAY);
    EXPECT_TRUE(gray.size()==bgr.size());
}


int main(int argc, char* argv[])
{
    testing::InitGoogleTest(&argc, argv);

    // Run a specific test only
    //testing::GTEST_FLAG(filter) = "MyLibrary.TestReading"; // I'm testing a new feature, run something quickly
    testing::GTEST_FLAG(filter) = "OpenCV.read_image";

    // Exclude a specific test
    //testing::GTEST_FLAG(filter) = "-cvtColorTwoPlane.yuv420sp_to_rgb:-cvtColorTwoPlane.rgb_to_yuv420sp"; // The writing test is broken, so skip it

    return RUN_ALL_TESTS();
}
