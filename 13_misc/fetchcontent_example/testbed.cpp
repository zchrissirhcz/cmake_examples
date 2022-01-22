#include <stdio.h>
#include <gtest/gtest.h>

#include <string>

TEST(hello, simple)
{
    EXPECT_TRUE(1+1 == 2);
}

int main(int argc, char* argv[])
{
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
