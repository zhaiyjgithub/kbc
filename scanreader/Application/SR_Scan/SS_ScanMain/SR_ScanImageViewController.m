//
//  SR_ScanImageViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/9/23.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_ScanImageViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+help.h"
#import "Watermark.h"

#import "SR_ScanNetPageViewController.h"
#import "SR_ScanResultNoneBookViewController.h"
#import <MBProgressHUD.h>
#import "SR_BookClubBookModel.h"
#import "AppDelegate.h"
#import "SR_InterPageListModel.h"
#import "SR_InterPageDetailViewController.h"
#import "globalHeader.h"
#import "httpTools.h"
#import "requestAPI.h"
#import "SR_ScanNetPageViewController.h"
#import "SR_FoundMainBookClubBookNoteListViewController.h"
#import "SR_OthersMineViewController.h"
#import "SR_MineViewController.h"
#import "UserInfo.h"

#import "QRView.h"
#import "QRUtil.h"


@interface SR_ScanImageViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureMetadataOutputObjectsDelegate,AVCaptureMetadataOutputObjectsDelegate>
//硬件设备
@property (nonatomic, strong) AVCaptureDevice *device;
//输入流
@property (nonatomic, strong) AVCaptureDeviceInput *input;
//协调输入输出流的数据
@property (nonatomic, strong) AVCaptureSession *session;
//预览层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

//输出流
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;  //用于捕捉静态图片
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;    //原始视频帧，用于获取实时图像以及视频录制
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;      //用于二维码识别以及人脸识别

//闪光灯
@property (nonatomic, strong) UIButton *torchButton;
//切换前后摄像头
@property (nonatomic, strong) UIButton *cameraButton;
//拍照
@property (nonatomic, strong) UIButton *takePhotoButton;

@property(nonatomic,assign)NSInteger scanImageDelegateCount;
@property(nonatomic,strong)QRView *qrView;
@property(nonatomic,strong)AVPlayer * localPlayer;
@end

@implementation SR_ScanImageViewController{
    BOOL stillImageFlag;
    BOOL videoDataFlag;
    BOOL metadataOutputFlag;
    UIImage *largeImage;
    UIImage *smallImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫描";
    [self.view.layer addSublayer:self.previewLayer];
    [self.view addSubview:self.qrView];
    [self.view addSubview:self.torchButton];
    [self.view addSubview:self.cameraButton];
    [self setupMenuButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.session startRunning];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.session stopRunning];
}

#pragma mark - 拍照
- (void)takePhoto{
    if (metadataOutputFlag) {
        return;
    }
    if (stillImageFlag) {
        [self screenshot];
    }else if (videoDataFlag){
        [self saveImageToPhotoAlbum:largeImage];
        [self saveImageToPhotoAlbum:smallImage];
    }
    [self.session stopRunning];
}

//AVCaptureStillImageOutput截取静态图片，会有快门声
-(void)screenshot{
    AVCaptureConnection * videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imageData];
        [self saveImageToPhotoAlbum:image];
        
        
    }];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
//AVCaptureVideoDataOutput获取实时图像，这个代理方法的回调频率很快，几乎与手机屏幕的刷新频率一样快
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    if (!videoDataFlag) {
        return;
    }
    
    //设置图像方向，否则largeImage取出来是反的
    if (self.scanImageDelegateCount > 20) {//由于执行的速度过快，因此会导致按钮等其他交互不能进行，因此在这里添加一个适当的转换时间
        [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
        largeImage = [self imageFromSampleBuffer:sampleBuffer];
        smallImage = [largeImage imageCompressTargetSize:CGSizeMake(512.0f, 512.0f)];
        [Watermark recognitionWithImage:smallImage result:^(BOOL status, NSString *content) {
            if (status) {
                [self.session stopRunning];
                NSString * value1 = [content substringToIndex:content.length/2];
                NSString * value2 = [content substringFromIndex:content.length/2];
                if ([value1 isEqualToString:value2]) {
                    NSURL * soundUrl = [[NSBundle mainBundle] URLForResource:@"sound.caf" withExtension:nil];
                    self.localPlayer = [[AVPlayer alloc] initWithURL:soundUrl];
                    [self.localPlayer play];
                    [self readList:@"mark" code:value1];
                }else{
                    [self.session startRunning];
                }
            }
        }];
        self.scanImageDelegateCount = 0;
    }else{
        self.scanImageDelegateCount +=1;
    }
    
    
}

//CMSampleBufferRef转NSImage
-(UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer{
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

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (!metadataOutputFlag) {
        return;
    }
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex :0];
#ifndef FACE
        [self.session stopRunning];
        NSURL * soundUrl = [[NSBundle mainBundle] URLForResource:@"sound.caf" withExtension:nil];
        self.localPlayer = [[AVPlayer alloc] initWithURL:soundUrl];
        [self.localPlayer play];
        NSString * value = metadataObject.stringValue;
        if ([value hasPrefix:@"http"]) {//如果返回的是http
            self.hidesBottomBarWhenPushed = YES;
            SR_ScanNetPageViewController * netPageVC = [[SR_ScanNetPageViewController alloc] init];
            netPageVC.url = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [self.navigationController pushViewController:netPageVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else{//9787508819341 == isbn
            //这里利用二维码请求后台
            [self readList:@"isbn" code:value];
        }

#else
        AVMetadataObject *faceData = [self.previewLayer transformedMetadataObjectForMetadataObject:metadataObject];
        NSLog(@"faceData is : %@",faceData);
#endif
    }
}

- (void)readList:(NSString * )method code:(NSString *)code{
    NSMutableDictionary * param = [NSMutableDictionary new];
    if ([method isEqualToString:@"mark"]) {//读取水印图
        param[@"mark"] = code;
    }else if ([method isEqualToString:@"isbn"]){//读取isbn
        param[@"isbn"] = code;
    }
    //这个用于记录用户的扫描列表
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    param[@"user_id"] = userId;
    param[@"user_token"] = userToken;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [httpTools post:SCAN_READ andParameters:param success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        SSLog(@"请求后台code:%@",dic);
        if (!dic[@"data"][@"record"]) {//如果没有数据就
            if ([method isEqualToString:@"isbn"]) {//isbn找不到就提示创建读书会
                self.hidesBottomBarWhenPushed = YES;
                SR_ScanResultNoneBookViewController * noneBookVC = [[SR_ScanResultNoneBookViewController alloc] init];
                [self.navigationController pushViewController:noneBookVC animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }
        }else{//读取isbn 水印图结果
            //对象优先
            if (dic[@"data"][@"record"][@"target_type"]){
                if ([dic[@"data"][@"record"][@"target_type"] isEqualToString:@"book"]) {//跳转到书本
                    SR_FoundMainBookClubBookNoteListViewController * bookMarkListVC = [[SR_FoundMainBookClubBookNoteListViewController alloc] init];
                    SR_BookClubBookModel * bookModel = [[SR_BookClubBookModel alloc] init];
                    bookModel.book_id = dic[@"data"][@"record"][@"target_id"];
                    bookMarkListVC.bookModel = bookModel;
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:bookMarkListVC animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                }else if ([dic[@"data"][@"record"][@"target_type"] isEqualToString:@"page"]) {//跳转到互动页
                    SR_InterPageDetailViewController * pageDetailVC = [[SR_InterPageDetailViewController alloc] init];
                    SR_InterPageListModel * pageListModel = [[SR_InterPageListModel alloc] init];
                    pageListModel.pageId = dic[@"data"][@"record"][@"target_id"];
                    pageDetailVC.pageListModel = pageListModel;
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:pageDetailVC animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                }else if ([dic[@"data"][@"record"][@"target_type"] isEqualToString:@"user"]){
                    if ([dic[@"data"][@"record"][@"target_type"] isEqualToString:[UserInfo getUserId]]) {
                        SR_MineViewController * mineVC = [[SR_MineViewController alloc] init];
                        self.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:mineVC animated:YES];
                        self.hidesBottomBarWhenPushed = NO;
                    }else{
                        SR_OthersMineViewController * otherVC = [[SR_OthersMineViewController alloc] init];
                        SR_BookClubNoteUserModel * userModel = [[SR_BookClubNoteUserModel alloc] init];
                        userModel.user_id = dic[@"data"][@"record"][@"target_id"];
                        otherVC.userModel = userModel;
                        self.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:otherVC animated:YES];
                        self.hidesBottomBarWhenPushed = NO;
                    }
                }
            }else{
                self.hidesBottomBarWhenPushed = YES;
                SR_ScanNetPageViewController * netPageVC = [[SR_ScanNetPageViewController alloc] init];
                netPageVC.url = dic[@"data"][@"record"][@"url"];
                [self.navigationController pushViewController:netPageVC animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
    
#pragma mark - 保存至相册
- (void)saveImageToPhotoAlbum:(UIImage*)savedImage{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

//指定回调方法
- (void)image: (UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (image == nil) {
        return;
    }
    NSString *msg = @"保存图片成功";
    if(error != NULL){
        msg = @"保存图片失败" ;
    }
    NSLog(@"%@",msg);
}

#pragma mark - 手电筒
-(void)openTorch:(UIButton*)button{
    button.selected = !button.selected;
    [self turnTorchOn:button.selected];
}

- (void)turnTorchOn:(BOOL)on{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        if ([self.device hasTorch] && [self.device hasFlash]){
            [self.device lockForConfiguration:nil];
            if (on) {
                [self.device setTorchMode:AVCaptureTorchModeOn];
                
            } else {
                [self.device setTorchMode:AVCaptureTorchModeOff];
            }
            [self.device unlockForConfiguration];
        }
    }
}

#pragma mark - 切换前后摄像头
- (void)switchCamera{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        AVCaptureDevicePosition position = [[self.input device] position];
        if (position == AVCaptureDevicePositionFront){
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }else {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
        }
        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
        if (newInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:self.input];
            if ([self.session canAddInput:newInput]) {
                [self.session addInput:newInput];
                self.input = newInput;
            }else {
                [self.session addInput:self.input];
            }
            [self.session commitConfiguration];
        }
    }
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}

#pragma mark - 菜单按钮
-(void)scanMenuChange:(UIButton *)aButton{
    if (!self.session.isRunning) {
        [self.session startRunning];
    }
    stillImageFlag = NO;
    videoDataFlag = NO;
    metadataOutputFlag = NO;
    switch (aButton.tag) {
        case 10:
        {
            stillImageFlag = YES;
        }
            break;
        case 11: //扫码
        {
            metadataOutputFlag = YES;
            self.scanImageDelegateCount = 0;
        }
            break;
        case 12:{//扫图
            videoDataFlag = YES;
            largeImage = nil;
            smallImage = nil;
        }
            break;
            
        default:
            break;
    }
    for (int i = 10; i < 13; i ++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        button.selected = NO;
    }
    for (int i = 100; i < 102; i ++) {
        UILabel *titleLabel = (UILabel *)[self.view viewWithTag:i];
        titleLabel.textColor = [UIColor lightGrayColor];
    }
    aButton.selected = YES;
    UILabel *titleLabel = (UILabel *)[self.view viewWithTag:aButton.tag - 11 + 100];
    titleLabel.textColor = baseColor;
}

-(void)setupMenuButton{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    NSArray * titles = @[@"扫码",@"扫图"];
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 150.0f, 51, 49.0f);
        button.center = CGPointMake(i*(width/2) + width/4, [UIScreen mainScreen].bounds.size.height - 120.0f);
        button.tag = 11 + i;
        [button addTarget:self action:@selector(scanMenuChange:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        if (i == 0) {
            [self scanMenuChange:button];
            [button setImage:[UIImage imageNamed:@"sm_sm_hl"] forState:(UIControlStateSelected)];
            [button setImage:[UIImage imageNamed:@"sm_sm_nor"] forState:(UIControlStateNormal)];
        }else{
            
            [button setImage:[UIImage imageNamed:@"sm_st_hl"] forState:(UIControlStateSelected)];
            [button setImage:[UIImage imageNamed:@"sm_st_nor"] forState:(UIControlStateNormal)];
        }
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x , button.frame.origin.y + button.frame.size.height, button.frame.size.width, 16)];
        titleLabel.text = titles[i];
        titleLabel.tag = 100 + i;
        if (i == 0) {
            titleLabel.textColor = baseColor;
        }else{
            titleLabel.textColor = [UIColor lightGrayColor];
        }
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:titleLabel];
    }
    
}

#pragma mark - getter
-(AVCaptureDevice *)device{
    if (_device == nil) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([_device lockForConfiguration:nil]) {
            //自动闪光灯
            if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
                [_device setFlashMode:AVCaptureFlashModeAuto];
            }
            //自动白平衡
            if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
                [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
            }
            //自动对焦
            if ([_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                [_device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            }
            //自动曝光
            if ([_device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
                [_device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            }
            [_device unlockForConfiguration];
        }
    }
    return _device;
}

-(AVCaptureDeviceInput *)input{
    if (_input == nil) {
        _input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    }
    return _input;
}

-(AVCaptureStillImageOutput *)stillImageOutput{
    if (_stillImageOutput == nil) {
        _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    }
    return _stillImageOutput;
}

-(AVCaptureVideoDataOutput *)videoDataOutput{
    if (_videoDataOutput == nil) {
        _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        [_videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        //设置像素格式，否则CMSampleBufferRef转换NSImage的时候CGContextRef初始化会出问题
        [_videoDataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    }
    return _videoDataOutput;
}

-(AVCaptureMetadataOutput *)metadataOutput{
    if (_metadataOutput == nil) {
        _metadataOutput = [[AVCaptureMetadataOutput alloc]init];
        [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //设置扫描区域
        _metadataOutput.rectOfInterest = self.view.bounds;
    }
    return _metadataOutput;
}

-(AVCaptureSession *)session{
    if (_session == nil) {
        _session = [[AVCaptureSession alloc] init];
        if ([_session canAddInput:self.input]) {
            [_session addInput:self.input];
        }
        if ([_session canAddOutput:self.stillImageOutput]) {
            [_session addOutput:self.stillImageOutput];
        }
        if ([_session canAddOutput:self.videoDataOutput]) {
            [_session addOutput:self.videoDataOutput];
        }
        if ([_session canAddOutput:self.metadataOutput]) {
            [_session addOutput:self.metadataOutput];
#ifndef FACE
            //设置扫码格式
            self.metadataOutput.metadataObjectTypes = @[
                                                        AVMetadataObjectTypeQRCode,
                                                        AVMetadataObjectTypeEAN13Code,
                                                        AVMetadataObjectTypeEAN8Code,
                                                        AVMetadataObjectTypeCode128Code
                                                        ];
#else
            self.metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeFace];
#endif
        }
    }
    return _session;
}

-(AVCaptureVideoPreviewLayer *)previewLayer{
    if (_previewLayer == nil) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        _previewLayer.frame = self.view.layer.bounds;
    }
    return _previewLayer;
}

-(UIButton *)torchButton{
    if (_torchButton == nil) {
        _torchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _torchButton.frame = CGRectMake(0.0f, 32.0f, 100.0f, 64.0f);
        [_torchButton setImage:[UIImage imageNamed:@"flash_icon"] forState:UIControlStateNormal];
        [_torchButton setImage:[UIImage imageNamed:@"flash_icon1"] forState:UIControlStateSelected];
        [_torchButton addTarget:self action:@selector(openTorch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _torchButton;
}

-(UIButton *)cameraButton{
    if (_cameraButton == nil) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraButton.frame = CGRectMake(self.view.frame.size.width - 100.0f, 32.0f, 100.0f, 64.0f);
        [_cameraButton setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        [_cameraButton addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraButton;
}

-(UIButton *)takePhotoButton{
    if (_takePhotoButton == nil) {
        _takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _takePhotoButton.frame = CGRectMake(15.0f, self.view.frame.size.height - 91.0f, self.view.frame.size.width - 30.0f, 42.0f);
        _takePhotoButton.backgroundColor = [UIColor redColor];
        [_takePhotoButton setTitle:@"拍照" forState:UIControlStateNormal];
        [_takePhotoButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
        _takePhotoButton.layer.cornerRadius = 5.0f;
        [_takePhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _takePhotoButton;
}

-(QRView *)qrView{
    if (!_qrView){
        CGRect screenRect = [QRUtil screenBounds];
        _qrView = [[QRView alloc] initWithFrame:screenRect];

        _qrView.transparentArea = CGSizeMake(260, 260);
        
        _qrView.backgroundColor = [UIColor clearColor];
        //_qrView.delegate = self;
    }
    return _qrView;
}


@end
