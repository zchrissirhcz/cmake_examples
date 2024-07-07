/*
 * Project:  Inverse Perspective Mapping
 *
 * File:     main.cpp
 *
 * Contents: Creation, initialisation and usage of IPM object
 *           for the generation of Inverse Perspective Mappings of images or videos
 *
 * Author:   Marcos Nieto <marcos.nieto.doncel@gmail.com>
 * Date:	 22/02/2014
 * Homepage: http://marcosnietoblog.wordpress.com/
 */

#include "opencv2/core/core.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include <iostream>
#include <stdio.h>
#include <ctime>

#include "IPM.h"

using namespace cv;
using namespace std;

int main( int _argc, char** _argv )
{
	// Images
	Mat inputImg, inputImgGray;
	Mat outputImg;
	
	if( _argc != 2 )
	{
		cout << "Usage: ipm.exe <videofile>" << endl;
		return 1;
	}

	// Video
	string videoFileName = _argv[1];	
	cv::VideoCapture video;
	if( !video.open(videoFileName) )
		return 1;

	// Show video information
	int width = 0, height = 0, fps = 0, fourcc = 0;	
	width = static_cast<int>(video.get(CV_CAP_PROP_FRAME_WIDTH));
	height = static_cast<int>(video.get(CV_CAP_PROP_FRAME_HEIGHT));
	fps = static_cast<int>(video.get(CV_CAP_PROP_FPS));
	fourcc = static_cast<int>(video.get(CV_CAP_PROP_FOURCC));

	cout << "Input video: (" << width << "x" << height << ") at " << fps << ", fourcc = " << fourcc << endl;
	
	// The 4-points at the input image	
	vector<Point2f> origPoints;
	origPoints.push_back( Point2f(0, height) );
	origPoints.push_back( Point2f(width, height) );
	origPoints.push_back( Point2f(width/2+30, 140) );
	origPoints.push_back( Point2f(width/2-50, 140) );

	// The 4-points correspondences in the destination image
	vector<Point2f> dstPoints;
	dstPoints.push_back( Point2f(0, height) );
	dstPoints.push_back( Point2f(width, height) );
	dstPoints.push_back( Point2f(width, 0) );
	dstPoints.push_back( Point2f(0, 0) );
		
	// IPM object
	IPM ipm( Size(width, height), Size(width, height), origPoints, dstPoints );
	
	// Main loop
	int frameNum = 0;
	for( ; ; )
	{
		printf("FRAME #%6d ", frameNum);
		fflush(stdout);
		frameNum++;

		// Get current image		
		video >> inputImg;
		if( inputImg.empty() )
			break;

		 // Color Conversion
		 if(inputImg.channels() == 3)		 
			 cvtColor(inputImg, inputImgGray, CV_BGR2GRAY);				 		 
		 else	 
			 inputImg.copyTo(inputImgGray);			 		 

		 // Process
		 clock_t begin = clock();
		 ipm.applyHomography( inputImg, outputImg );		 
		 clock_t end = clock();
		 double elapsed_secs = double(end - begin) / CLOCKS_PER_SEC;
		 printf("%.2f (ms)\r", 1000*elapsed_secs);
		 ipm.drawPoints(origPoints, inputImg );

		 // View		
		 imshow("Input", inputImg);
		 imshow("Output", outputImg);
		 waitKey(1);
	}

	return 0;	
}		
