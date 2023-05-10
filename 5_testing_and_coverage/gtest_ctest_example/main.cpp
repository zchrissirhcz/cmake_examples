
#include <stdio.h>
#include <gtest/gtest.h>

int add(int a, int b)
{
    return a + b;
}

TEST(add, test0)
{
    EXPECT_EQ(14, add(4, 10));
}
 
TEST(add, test1)
{
    EXPECT_EQ(6, add(5, 7));
}
 
TEST(add, test2)
{
    EXPECT_EQ(28, add(10, 18));
}


int main(int argc, char* argv[])
{
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
