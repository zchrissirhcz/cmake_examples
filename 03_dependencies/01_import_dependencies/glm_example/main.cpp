#include <glm/vec3.hpp> // glm::vec3
#include <glm/vec4.hpp> // glm::vec4
#include <glm/mat4x4.hpp> // glm::mat4
#include <glm/ext/matrix_transform.hpp> // glm::translate, glm::rotate, glm::scale
#include <glm/ext/matrix_clip_space.hpp> // glm::perspective
#include <glm/ext/scalar_constants.hpp> // glm::pi

#include <iostream>

int main()
{
    glm::vec4 vec(1.0f, 0.0f, 0.0f, 1.0f);//创建一个点
    glm::mat4 trans = glm::mat4(1.0f);//创建单位矩阵
    trans = glm::translate(trans, glm::vec3(1.0, 1.0, 1.0));//设置平移矩阵
    vec = trans * vec;//变换矩阵左乘点向量，获得变换后的点
    std::cout << vec.x << vec.y << vec.z << std::endl;
}
// ————————————————
// 版权声明：本文为CSDN博主「haowenlai2008」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
// 原文链接：https://blog.csdn.net/haowenlai2008/article/details/88853263