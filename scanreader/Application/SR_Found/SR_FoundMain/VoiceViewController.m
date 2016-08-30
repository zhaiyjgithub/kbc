//
//  VoiceViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/8/17.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "VoiceViewController.h"
#import "VoiceConverter.h"
@import AVFoundation;
@import AudioToolbox;
#import "httpTools.h"
#import "requestAPI.h"
#import "MBProgressHUD.h"
#import "UserInfo.h"
#import "globalHeader.h"
#import "SVProgressHUD.h"

@interface VoiceViewController ()
//! 播放转换后wavBtn
@property (strong,nonatomic)UIButton *playConvertedBtn;
//! 录音btn
@property (strong,nonatomic)UIButton *recordBtn;
//! 播放原wavBtn
@property (strong,nonatomic)UIButton *playOriginalWavBtn;

//! amr转wav
@property (strong,nonatomic)UILabel *toWavLabel;
//! wav转amr
@property (strong,nonatomic)UILabel *toAmrLabel;
//! 原wav
@property (strong,nonatomic)UILabel *originalWavLabel;

@property (strong,nonatomic)AVAudioRecorder  *recorder;
@property (strong,nonatomic)AVAudioPlayer    *player;
@property (strong,nonatomic)NSString         *recordFileName;
@property (strong,nonatomic)NSString         *recordFilePath;
@property(nonatomic,strong)AVPlayer * remotePlayer;
@end

@implementation VoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"录音";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.playConvertedBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 60, 40)];
    [self.playConvertedBtn setTitle:@"后wav" forState:(UIControlStateNormal)];
    [self.playConvertedBtn addTarget:self action:@selector(playConverted:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.playConvertedBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.view addSubview:self.playConvertedBtn];
    self.toWavLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 100, 150, 40)];
    self.toWavLabel.font = [UIFont systemFontOfSize:12.0];
    self.toWavLabel.text = @"towav";
    [self.view addSubview:self.toWavLabel];
    
    self.recordBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 160, 60, 40)];
    [self.recordBtn setTitle:@"录音" forState:(UIControlStateNormal)];
    [self.recordBtn addTarget:self action:@selector(record:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.recordBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.view addSubview:self.recordBtn];
    
    
    self.playOriginalWavBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 220, 60, 40)];
    [self.playOriginalWavBtn setTitle:@"原wav" forState:(UIControlStateNormal)];
    [self.playOriginalWavBtn addTarget:self action:@selector(playOriginalWav:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.playOriginalWavBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.view addSubview:self.playOriginalWavBtn];
    
    self.originalWavLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 220, 150, 40)];
    self.originalWavLabel.font = [UIFont systemFontOfSize:12.0];
    self.originalWavLabel.text = @"origin";
    [self.view addSubview:self.originalWavLabel];
    
    self.toAmrLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 280, 150, 40)];
    self.toAmrLabel.font = [UIFont systemFontOfSize:12.0];
    self.toAmrLabel.text = @"toamr";
    [self.view addSubview:self.toAmrLabel];
    
    UIButton * uploadBtn = [[UIButton alloc] initWithFrame:CGRectMake(159, 220, 60, 40)];
    [uploadBtn setTitle:@"upload" forState:(UIControlStateNormal)];
    [uploadBtn addTarget:self action:@selector(upload) forControlEvents:(UIControlEventTouchUpInside)];
    [uploadBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.view addSubview:uploadBtn];
    
    self.player = [[AVAudioPlayer alloc] init];
    
}

#pragma mark - 录音
- (void)record:(UIButton *)sender{
    
    if (self.recorder.isRecording){//录音中
        //停止录音
        [self.recorder stop];
        [sender setTitle:@"录音" forState:UIControlStateNormal];
        
//        self.playOriginalWavBtn.enabled = YES;
//        //设置label信息
//        self.originalWavLabel.text = [NSString stringWithFormat:@"原wav:\n%@",[self getVoiceFileInfoByPath:self.recordFilePath convertTime:0]];
//        
//        //开始转换格式
//        
//        NSDate *date = [NSDate date];
//        NSString *amrPath = [self GetPathByFileName:self.recordFileName ofType:@"amr"];
//        
//#warning wav转amr
//        if ([VoiceConverter ConvertWavToAmr:self.recordFilePath amrSavePath:amrPath]){
//            
//            //设置label信息
//            self.toAmrLabel.text = [NSString stringWithFormat:@"原wav转amr:\n%@",[self getVoiceFileInfoByPath:amrPath convertTime:[[NSDate date] timeIntervalSinceDate:date]]];
//            
//            date = [NSDate date];
//            NSString *convertedPath = [self GetPathByFileName:[self.recordFileName stringByAppendingString:@"_AmrToWav"] ofType:@"wav"];
//            
//#warning amr转wav
//            if ([VoiceConverter ConvertAmrToWav:amrPath wavSavePath:convertedPath]){
//                //设置label信息
//                self.toWavLabel.text = [NSString stringWithFormat:@"amr转wav:\n%@",[self getVoiceFileInfoByPath:convertedPath convertTime:[[NSDate date] timeIntervalSinceDate:date]]];
//                self.playConvertedBtn.enabled = YES;
//            }else
//                NSLog(@"amr转wav失败");
//            
//        }else
//            NSLog(@"wav转amr失败");
//        self.player = [self.player initWithContentsOfURL:[NSURL URLWithString:self.recordFilePath] error:nil];
//        [self.player play];
        if (self.remotePlayer == nil) {
            NSLog(@"player is nil");
        }
        NSURL * url = [NSURL fileURLWithPath:self.recordFilePath];
        self.remotePlayer = [[AVPlayer alloc] initWithURL:url];
        [self.remotePlayer play];
        
    }else{
        //录音
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *setCategoryError = nil;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&setCategoryError];
        
        if(setCategoryError){
            NSLog(@"setCategoryError:%@", [setCategoryError description]);
        }
        //根据当前时间生成文件名
        self.recordFileName = [self GetCurrentTimeString];
        //获取路径
        self.recordFilePath = [self GetPathByFileName:self.recordFileName ofType:@"wav"];
        
        //初始化录音
        self.recorder = [[AVAudioRecorder alloc]initWithURL:[NSURL fileURLWithPath:self.recordFilePath]
                                                   settings:[VoiceConverter GetAudioRecorderSettingDict]
                                                      error:nil];
        //准备录音
        if ([self.recorder prepareToRecord]){
            
            [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
            
            //开始录音
            if ([self.recorder record]){
                [sender setTitle:@"停止" forState:UIControlStateNormal];
                self.playConvertedBtn.enabled = NO;
                self.playOriginalWavBtn.enabled = NO;
                
            }
        }
    }
}

#pragma mark - 播放原wav
- (void)playOriginalWav:(UIButton *)sender {
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    NSLog(@"原来wav path:%@",self.recordFilePath);
    
    if (self.player == nil) {
        NSLog(@"player is nil");
    }
    
    self.player = [self.player initWithContentsOfURL:[NSURL URLWithString:self.recordFilePath] error:nil];
    [self.player play];
}

- (void)upload{
    NSLog(@"原来wav path:%@",self.recordFilePath);
    NSString * fileAttr =  [self getVoiceFileInfoByPath:self.recordFilePath convertTime:0];
    NSLog(@"file attr:%@",fileAttr);
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    NSDictionary * param = @{@"user_id":userId,@"user_token":userToken,@"type":NOTE_TYPE_VOICE,
                             @"title":@"录音"};
    self.player = [self.player initWithContentsOfURL:[NSURL URLWithString:self.recordFilePath] error:nil];
    [self.player play];
    //这里的提示不起作用，用户可能会重复点发送按钮，
//    MBProgressHUD * hud = [[MBProgressHUD  alloc] initWithView:self.view];
//    [hud showAnimated:YES];
//    NSArray * voicesUrl = @[self.recordFilePath];
//    NSURL * url = [NSURL fileURLWithPath:self.recordFilePath];
//    NSData * data = [NSData dataWithContentsOfURL:url];
//    [httpTools uploadVoice:SAVE_NOTE parameters:param voicesUrl:voicesUrl success:^(NSDictionary *dic) {
//        SSLog(@"save pic:%@",dic);
//
//    } failure:^(NSError *error) {
//        NSLog(@"error:%@",error);
//    }];

}

#pragma mark - 播放amr转换后wav
- (void)playConverted:(UIButton *)sender {
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    NSString *convertedPath = [self GetPathByFileName:[self.recordFileName stringByAppendingString:@"_AmrToWav"] ofType:@"wav"];
    self.player = [self.player initWithContentsOfURL:[NSURL URLWithString:convertedPath] error:nil];
    [self.player play];
}

#pragma mark - Others

#pragma mark - 生成当前时间字符串
- (NSString*)GetCurrentTimeString{
    NSDateFormatter *dateformat = [[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateformat stringFromDate:[NSDate date]];
}

#pragma mark - 生成文件路径
- (NSString*)GetPathByFileName:(NSString *)_fileName ofType:(NSString *)_type{
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString* fileDirectory = [[[directory stringByAppendingPathComponent:_fileName]
                                stringByAppendingPathExtension:_type]
                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return fileDirectory;
}

#pragma mark - 获取音频文件信息
- (NSString *)getVoiceFileInfoByPath:(NSString *)aFilePath convertTime:(NSTimeInterval)aConTime{
    
    NSInteger size = [self getFileSize:aFilePath]/1024;
    NSString *info = [NSString stringWithFormat:@"文件名:%@\n文件大小:%dkb\n",aFilePath.lastPathComponent,size];
    
    NSRange range = [aFilePath rangeOfString:@"wav"];
    if (range.length > 0) {
        AVAudioPlayer *play = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:aFilePath] error:nil];
        info = [info stringByAppendingFormat:@"文件时长:%f\n",play.duration];
    }
    
    if (aConTime > 0)
        info = [info stringByAppendingFormat:@"转换时间:%f",aConTime];
    return info;
}

#pragma mark - 获取文件大小
- (NSInteger) getFileSize:(NSString*) path{
    NSFileManager * filemanager = [[NSFileManager alloc]init];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue];
        else
            return -1;
    }
    else{
        return -1;
    }
}



@end
