// CamShift+Kalman.cpp : �������̨Ӧ�ó������ڵ㡣
//

#include "stdafx.h"
#include<iostream>
using namespace std;
#include <stdio.h>

#include <cxcore.h>

#include <cv.h>

#include <highgui.h>
#include <time.h>
#include <dos.h>
//*************************************
//�������ο�B��ʹ����A�ķ�Χ
CvRect my_ChangeRect(CvRect A, CvRect B)
{
	if (B.x<A.x)
		B.x = A.x;
	if (B.x + B.width>A.width)
		B.width = A.width - B.x;
	if (B.y<A.y)
		B.y = A.y;
	if (B.y + B.height>A.height)
		B.height = A.height - B.y;
	return(B);
}
//**************************************
//kalman��ʼ��������http://blog.sina.com.cn/s/blog_71ee19c30101axq0.html
CvKalman* InitializeKalman(CvKalman* kalman)
{

	const float A[] = { 1,0,1,0,
		0,1,0,1,
		0,0,1,0,
		0,0,0,1 };
	kalman = cvCreateKalman(4, 2, 0);//״̬����������������ά��
	memcpy(kalman->transition_matrix->data.fl, A, sizeof(A));//A
	//memcpy�����Ĺ����Ǵ�Դsrc��ָ���ڴ��ַ����ʼλ�ÿ�ʼ����n���ֽڵ�Ŀ��dest��ָ���ڴ��ַ����ʼλ���С�
	cvSetIdentity(kalman->measurement_matrix, cvScalarAll(1));//H���ú����������ǽ�������������ȵ�Ԫ����Ϊ1������Ԫ����Ϊ0
	cvSetIdentity(kalman->process_noise_cov, cvScalarAll(1e-5));//Q w ��
	cvSetIdentity(kalman->measurement_noise_cov, cvScalarAll(1e-1));//R v
	cvSetIdentity(kalman->error_cov_post, cvScalarAll(1));//P
	return kalman;
}
//***************************************
//point1��һ֡���ģ�point2��ǰ֡���ģ���x,y,vx,vy����kalman->state_post
void GetCurentState(CvKalman* kalman, CvPoint point1, CvPoint point2)
{
	float input[4] = { point2.x, point2.y, point2.x - point1.x, point2.y - point1.y };//currentstate
	memcpy(kalman->state_post->data.fl, input, sizeof(input));
}
//****************************************
//point1��һ֡���ģ�point2��ǰ֡���ģ���x,y,vx,vy�������
CvMat* GetMeasurement(CvMat* mat, CvPoint point1, CvPoint point2)
{
	float input[4] = { point2.x, point2.y, point2.x - point1.x, point2.y - point1.y };
	memcpy(mat->data.fl, input, sizeof(input));
	return mat;
}
/*****************************************/
#define region 50
#define calc_point(kalman) cvPoint( cvRound(kalman[0]),cvRound(kalman[1]))////��һ��double�͵��������������룻��λ�ö�Ӧ������ֵ

IplImage *image = 0, *hsv = 0, *hue = 0, *mask = 0, *histimg = 0;
CvHistogram *hist;
IplImage *backproject;

CvPoint lastpoint; //��һ֡����������
CvPoint predictpoint, measurepoint;//Ԥ�������Լ���ǰ֡������

int select_object = 0;
int track_object;

CvPoint origin;
CvPoint point_text;
CvRect selection;
CvRect origin_box;

CvRect track_window;
CvBox2D track_box; // tracking ���ص����� box�����Ƕ�
CvConnectedComp track_comp;
int hdims = 256; // ����HIST�ĸ�����Խ��Խ��ȷ
float hranges_arr[] = { 0,180 };
float* hranges = hranges_arr;
int vmin = 10, vmax = 256, smin = 30;
int start_track = 0;
CvFont font;//��ʾ���ı�����
char nchar[10];//��ʾ�����ַ�����
CvMat* measurement;
CvMat* realposition;
const CvMat* prediction;
CvRect search_window;
int filename1_n = 0;
int frame_count = 0;

void on_mouse(int event, int x, int y, int flags, void *p)
{
	if (!image)
		return;

	if (image->origin)
		y = image->height - y;

	if (select_object)
	{
		selection.x = MIN(x, origin.x);
		selection.y = MIN(y, origin.y);
		selection.width = selection.x + CV_IABS(x - origin.x);
		selection.height = selection.y + CV_IABS(y - origin.y);

		selection.x = MAX(selection.x, 0);
		selection.y = MAX(selection.y, 0);
		selection.width = MIN(selection.width, image->width);
		selection.height = MIN(selection.height, image->height);
		selection.width -= selection.x;
		selection.height -= selection.y;
		//cout << origin.x<< endl<<origin.y<<endl;
	}

	switch (event)
	{
	case CV_EVENT_LBUTTONDOWN:
		origin = cvPoint(x, y);
		selection = cvRect(x, y, 0, 0);
		select_object = 1;
		break;
	case CV_EVENT_LBUTTONUP:
		select_object = 0;
		if (selection.width > 0 && selection.height > 0)
			track_object = -1;
		origin_box = selection;


#ifdef _DEBUG
		printf("\n # ����ѡ������");
		printf("\n X = %d, Y = %d, Width = %d, Height = %d",
			selection.x, selection.y, selection.width, selection.height);
#endif
		break;
	}
}
/*************************************main***************************/
int main(int argc, char** argv)
{
	CvCapture* capture = 0;
	IplImage* frame = 0;
	//capture = cvCaptureFromCAM(0);
	time_t t = time(NULL);
	time_t t_ori = t;
	int x_ori = 0;
	int y_ori = 0;
	int vx = 0;
	int vy = 0;
	capture = cvCaptureFromAVI("ex2.avi");
	if (!capture)
	{
		fprintf(stderr, "Could not initialize capturing...\n");
		return -1;
	}

	cvNamedWindow("CamShiftDemo", 1);
	cvSetMouseCallback("CamShiftDemo", on_mouse, NULL); // on_mouse �Զ����¼�
	cvCreateTrackbar("Vmin", "CamShiftDemo", &vmin, 256, 0);
	cvCreateTrackbar("Vmax", "CamShiftDemo", &vmax, 256, 0);
	cvCreateTrackbar("Smin", "CamShiftDemo", &smin, 256, 0);
	//��ʼ��kalman
	CvKalman* kalman = 0;
	kalman = InitializeKalman(kalman);
	measurement = cvCreateMat(2, 1, CV_32FC1);//Z(k)������ת���ɾ�����ʽ��32λ�����͵�ͨ��
	realposition = cvCreateMat(4, 1, CV_32FC1);//real X(k)

	for (;;)
	{
		int i = 0, c;
		frame = cvQueryFrame(capture);//ץȡcapture��һ֡
		if (!frame)
			break;
		if (!image)
		{
			/* allocate all the buffers */
			image = cvCreateImage(cvGetSize(frame), 8, 3);
			image->origin = frame->origin;//��������@һ�е�Ԓ  ����copy������֮�ᣬimage->origin����β���_ʼ��  ����Ӱ������^��
			
			cout <<"��Ƶ���ڵĿ�Ϊ"<< cvGetSize(frame).width << endl << "��Ƶ���ڵĸ�Ϊ" << cvGetSize(frame).height << endl;
			hsv = cvCreateImage(cvGetSize(frame), 8, 3);
			hue = cvCreateImage(cvGetSize(frame), 8, 1);
			mask = cvCreateImage(cvGetSize(frame), 8, 1);

			backproject = cvCreateImage(cvGetSize(frame), 8, 1);
			backproject->origin = frame->origin;
			hist = cvCreateHist(1, &hdims, CV_HIST_ARRAY, &hranges, 1); // ����ֱ��ͼ

		}
		cvCopy(frame, image, 0);
		cvCvtColor(image, hsv, CV_BGR2HSV); // ��ɫ�ռ�ת�� BGR to HSV 
		frame_count++;
		//*******************************************************************************************
		if (track_object) //��ʼ����
		{
			int _vmin = vmin, _vmax = vmax;
			cvInRangeS(hsv, cvScalar(0, smin, MIN(_vmin, _vmax), 0),
				cvScalar(180, 256, MAX(_vmin, _vmax), 0), mask); // �õ���ֵ��MASK
			cvSplit(hsv, hue, 0, 0, 0); // ֻ��ȡ HUE ���� 
			if (track_object < 0)//��ʼ��
			{
				float max_val = 0.f;
				cvSetImageROI(hue, origin_box); 
				// �õ�ѡ������ for ROI��//���ڸ����ľ�������ͼ���ROI������Ȥ����region of interesting��
				cvSetImageROI(mask, origin_box); 
				// �õ�ѡ������ for mask
				cvCalcHist(&hue, hist, 0, mask); // ����ֱ��ͼ//����һ�Ż���ŵ�ͨ��ͼ���ֱ��ͼ��hueɫ��Hͨ����
				cvGetMinMaxHistValue(hist, 0, &max_val, 0, 0); // ֻ�����ֵ��//�ҵ�������Сֱ����
				cvConvertScale(hist->bins, hist->bins, max_val ? 255. / max_val : 0., 0); // ���� bin ������ [0,255] //ʹ�����Ա任ת������
				cvResetImageROI(hue); // remove ROI
				cvResetImageROI(mask);
				track_window = origin_box;
				track_object = 1;//��ֵ���1����model����  ����׷�v��

				/////////////////////
				lastpoint = predictpoint = cvPoint(track_window.x + track_window.width / 2,
					track_window.y + track_window.height / 2);//Ԥ���Ϊ�е�
				GetCurentState(kalman, lastpoint, predictpoint);//input curent state
			}



			//Ԥ��Ŀ����λ��(x,y,vx,vy), 
			prediction = cvKalmanPredict(kalman, 0);//predicton=kalman->state_post 
			predictpoint = calc_point(prediction->data.fl);//Ԥ������
			//Ԥ����ľ��ο�
			track_window = cvRect(predictpoint.x - track_window.width / 2, predictpoint.y - track_window.height / 2,
				track_window.width, track_window.height);//ͨ���������Ͻ�����;��εĿ�͸���ȷ��һ����������
			track_window = my_ChangeRect(cvRect(0, 0, frame->width, frame->height), track_window);//��track window����ͼ��Χ��
			//ֻ��Ŀ����Χ����ͶӰ
			search_window = cvRect(track_window.x - region, track_window.y - region,
				track_window.width + 2 * region, track_window.height + 2 * region);//track window�����50��һȦ��Χ
			//����search_window��ʹ�䷶Χ��ͼ����
			search_window = my_ChangeRect(cvRect(0, 0, frame->width, frame->height), search_window);
			cvSetImageROI(hue, search_window);
			cvSetImageROI(mask, search_window);
			cvSetImageROI(backproject, search_window);
			cvCalcBackProject(&hue, backproject, hist); 
			// ʹ�� back project ����//ֱ��ͼ�ķ���ͶӰ���Ա�ѡ����ֱ��ͼ��ͼ���ϵ�ֱ��ͼ���õ�λ��
			cvAnd(backproject, mask, backproject, 0);//������������İ�λ��Ľ��
			//��Ϊ������_1ROI�����Ը���track_window
			track_window = cvRect(region, region, track_window.width, track_window.height);
			// calling CAMSHIFT �㷨ģ�� 
			/* cvCamShift( backproject, track_window,
			cvTermCriteria( CV_TERMCRIT_EPS | CV_TERMCRIT_ITER, 10, 1 ),
			&track_comp, &track_box );*/
			cvMeanShift(backproject, track_window,
				cvTermCriteria(CV_TERMCRIT_EPS | CV_TERMCRIT_ITER, 10, 1),
				&track_comp);
			//******************************************************************************** 
			cvResetImageROI(hue);
			cvResetImageROI(mask);
			cvResetImageROI(backproject);
			track_window = track_comp.rect;//comp->rect�������󴰿�λ�ã�comp->area�����մ������������ص�ĺ�
			track_window = cvRect(track_window.x + search_window.x, track_window.y + search_window.y,
				track_window.width, track_window.height);
			//ʵ�ʵ��������� 
			measurepoint = cvPoint(track_window.x + track_window.width / 2,
				track_window.y + track_window.height / 2);
			
			int dx = abs(x_ori - measurepoint.x);
			int dy = abs(y_ori - measurepoint.y);
			x_ori = measurepoint.x;
			y_ori = measurepoint.y;
			t = time(NULL);
			time_t dt = t - t_ori;
			
			if (dt != 0)
			{
				t_ori = t;
				vx = dx / dt;
				vy = dy / dt;
			}

            cout <<"x����Ϊ"<< measurepoint.x << "��y����Ϊ"<<measurepoint.y<<",x�����ٶ�Ϊ"<<vx<<",y�����ٶ�Ϊ"<<vy<< ",�������Ϊ"<<dt*1000<<endl;
			realposition->data.fl[0] = measurepoint.x;
			realposition->data.fl[1] = measurepoint.y;
			realposition->data.fl[2] = measurepoint.x - lastpoint.x;
			realposition->data.fl[3] = measurepoint.y - lastpoint.y;
			lastpoint = measurepoint;//keep the current real position
									 //ʵ�������measurementֻ�ǵ�ǰ��x��y
			cvMatMulAdd(kalman->measurement_matrix/*2x4*/, realposition/*4x1*/,/*measurementstate*/ 0, measurement); //�ȳ˺��
			cvKalmanCorrect(kalman, measurement);
			cvRectangle(image, cvPoint(track_window.x, track_window.y),
				cvPoint(track_window.x + track_window.width, track_window.y + track_window.height),
				CV_RGB(255, 0, 0), 2, 8, 0);
			//��Ŀ���ǵڼ��������
			cvInitFont(&font, CV_FONT_HERSHEY_SIMPLEX, 1.0F, 1.0F, 0, 3, 8);
			sprintf(nchar, "ID:%d", i + 1);
			point_text = cvPoint(track_window.x, track_window.y + track_window.height);
			cvPutText(image, nchar, point_text, &font, CV_RGB(255, 255, 0));
		}
		//*********************************************************************************************** 
		if (select_object && selection.width > 0 && selection.height > 0)
		{
			cvSetImageROI(image, selection);
			cvXorS(image, cvScalarAll(255), image, 0);//�������������
			cvResetImageROI(image);
		}
		cvShowImage("CamShiftDemo", image);
		c = cvWaitKey(30);
		//���ݼ��̹رո���Ŀ��
		if (c == 27)
			break; // exit from for-loop 
	}
	cvReleaseCapture(&capture);
	cvDestroyWindow("CamShiftDemo");
	return 0;
}