//
//  FftOpencvFun.h
//  WMIOSLIB
//
//  Created by Lu Jianfeng on 6/27/14.
//  Copyright (c) 2014 Steven. All rights reserved.
//

#ifndef __WMIOSLIB__FftOpencvFun__
#define __WMIOSLIB__FftOpencvFun__

#include <iostream>

extern "C"
{

    bool FftOpencvFun(unsigned char* pInputImg, int w, int h, char* pout);   
    //水印检测接口函数
    //说明：
    //  参数： unsigned char* pInputImg  输入的三通道RGB图像数据
    //        char* pout  返回的检测出的字符
    //  返回值：
    //        TRUE ：成功
    //        FALSE ：失败
}
#endif
