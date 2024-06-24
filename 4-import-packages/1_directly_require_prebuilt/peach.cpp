/////////////////////////////////////////////////////////////
// Tree
// Platform	: Visual Studio 2022 (v143), EasyX_20240225
// Author	: 872289455@qq.com
// Date		: 2024-03-17
//

#pragma warning(disable:4305)
#pragma warning(disable:4244)

#define _USE_MATH_DEFINES
#include <random>
#include <queue>
#include <thread>
#include <easyx.h>

constexpr int WIDTH = 800;
constexpr int HEIGHT = 600;
constexpr float OFF_SET[] = { -M_PI / 6.f, -M_PI / 16.f, M_PI / 16.f, M_PI / 6.f };
constexpr float LENGTH[] = { 0.75f, 0.95f, 0.95f, 0.75f };

struct BranchInfo {
    float x, y;
    float length;
    float radians;
    float thickness;
    int level;
};

float RandomNum(float min, float max) {
    static std::mt19937 rand_num(std::chrono::system_clock::now().time_since_epoch().count());
    std::uniform_real_distribution<float> dist(min, max);
    return dist(rand_num);
}

void ReDraw() {
    cleardevice();
    std::queue<BranchInfo> branches({ BranchInfo{WIDTH / 2, HEIGHT, 100, -M_PI_2, 8.f, 1 } });
    while (!branches.empty()) {
        const auto &branch = branches.front();
        float dx = std::cosf(branch.radians);
        float dy = std::sinf(branch.radians);
        float x_end = branch.x + branch.length * dx;
        float y_end = branch.y + branch.length * dy;
        setlinestyle(PS_SOLID, branch.thickness);
        setlinecolor(HSVtoRGB(15, 0.75, 0.4 + branch.level * 0.05));
        line(branch.x, branch.y, x_end, y_end);
        if (branch.thickness > 2) {
            for (int i = 0; i < 4; i++)
                branches.push({ x_end, y_end, branch.length * LENGTH[i], branch.radians + OFF_SET[i], branch.thickness * 0.75f, branch.level + 1});
        }
        else {
            COLORREF  color = HSVtoRGB(RandomNum(300, 350), RandomNum(0.2, 0.3), 1);
            setlinecolor(color);
            setfillcolor(color);
            dx = RandomNum(-16.f, 16.f);
            dy = RandomNum(-16.f, 16.f);
            float r = (16.f - min(15.f, std::sqrtf(dx * dx + dy * dy))) / 16.f;
            fillcircle(x_end + dx, y_end + dy, max(r * 5.f, 1.f));
        }
        branches.pop();
        FlushBatchDraw();
    }
}

int main() {
    initgraph(WIDTH, HEIGHT);
    setbkcolor(RGB(255, 255, 255));
    BeginBatchDraw();
    ReDraw();
    while (true) {
        ExMessage msg;
        while (peekmessage(&msg)) {
            if (WM_LBUTTONDOWN == msg.message) {
                ReDraw();
            }
        }
    }
    return 0;
}