#include <gtest/gtest.h>

// Demonstrate some basic assertions.
TEST(HelloTest, BasicAssertions)
{
    // Expect equality.
    EXPECT_EQ(7 * 6, 42);

    // Expect two strings not to be equal.
    EXPECT_STRNE("hello", "world");
}

TEST(HelloTest, FailureExample)
{
    EXPECT_TRUE( 1 + 2 == 2 ); // will fail, on purpose
}

// main 函数可写可不写，写了的话可以进一步设置 只执行哪些testcase 或 不执行哪些case
// int main(int argc, char* argv[])
// {
//     testing::InitGoogleTest(&argc, argv);

//     // Run a specific test only
//     //testing::GTEST_FLAG(filter) = "MyLibrary.TestReading"; // I'm testing a new feature, run something quickly
//     testing::GTEST_FLAG(filter) = "OpenCV.read_image";

//     // Exclude a specific test
//     //testing::GTEST_FLAG(filter) = "-cvtColorTwoPlane.yuv420sp_to_rgb:-cvtColorTwoPlane.rgb_to_yuv420sp"; // The writing test is broken, so skip it

//     return RUN_ALL_TESTS();
// }