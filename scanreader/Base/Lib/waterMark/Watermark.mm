//
//  Watermark.m
//  Scanner
//
//  Created by 戴尼玛 on 16/7/19.
//  Copyright © 2016年 MIMO. All rights reserved.
//

#import "Watermark.h"
#import <stdio.h>
#import "FftOpencvFun.h"
//#import <opencv2/opencv.hpp>
//#import <opencv2/imgproc/types_c.h>
//#import <opencv2/highgui/highgui.hpp>

#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>

#import <opencv2/highgui/highgui.hpp>


@implementation Watermark

+(void)recognitionWithImage:(UIImage *)aImage result:(void(^)(BOOL isOk, NSString* content))aResultBlock{

    CFDataRef bitmapData = CGDataProviderCopyData(CGImageGetDataProvider(aImage.CGImage));
    char *imageData = (char *)CFDataGetBytePtr(bitmapData);
    //每一个像素点都占据了四个字节的长度，依次序分别是RGBA，即红色、绿色、蓝色值和透明度值
    unsigned char buff[512*512*3];
    int i;
    int j;
    
    //转化RGBA －－> BGR格式数组中
    for(i=0; i<512; i++) {
        for(j=0; j<512; j++) {
            
            buff[(i*512+j)*3 ]    = imageData[(i*512+j)*4 + 2];  // B
            buff[(i*512+j)*3 + 1] = imageData[(i*512+j)*4 + 1];  // G
            buff[(i*512+j)*3 + 2] = imageData[(i*512+j)*4 + 0];  // R
            
        }
    }
    
    CFRelease(bitmapData);

    char result[50];
    bool ret = FftOpencvFun(buff,  512, 512, result);
    printf("ret is : %d\n", ret);
    printf("result is : %s\n", result);
    NSString *content = [NSString stringWithUTF8String:result];
    if (aResultBlock) {
        aResultBlock(ret,content);
    }
}


+(UIImage *)imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer{
    // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // 锁定pixel buffer的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    // 得到pixel buffer的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // 得到pixel buffer的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 得到pixel buffer的宽和高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    // 创建一个依赖于设备的RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // 根据这个位图context中的像素数据创建一个Quartz image对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    // 释放context和颜色空间
    CGContextRelease(context); CGColorSpaceRelease(colorSpace);
    // 用Quartz image创建一个UIImage对象image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    // 释放Quartz image对象
    CGImageRelease(quartzImage);
    return (image);
}

@end
