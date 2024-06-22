#include <opencv2/opencv.hpp>
#include <iostream>

int main() {
    std::string videoFile = "C:/pkgs/opencv/sources/samples/data/tree.avi";
    cv::VideoCapture cap(videoFile);
    
    if (!cap.isOpened()) {
        std::cerr << "failed to open video file " << videoFile << std::endl;
        return -1;
    }

    int frameCount = static_cast<int>(cap.get(cv::CAP_PROP_FRAME_COUNT));
    std::cout << "frame count: " << frameCount << std::endl;

    // play the video, frame by frame
    for (int i = 0; i < frameCount; i++)
    {
        cv::Mat frame;
        cap >> frame;
        if (frame.empty())
        {
            break;
        }
        cv::imshow("video", frame);
        cv::waitKey(30);
    }
    cv::destroyAllWindows();

    return 0;
}