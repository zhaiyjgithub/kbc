//
//  videoViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/8/31.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "videoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#define url @"http://www.tudou.com/programs/view/html5embed.action?type=0&code=YsjDAXSXJ6Q&lcode=&resourceId=0_06_05_99"

@interface videoViewController ()
@property(nonatomic,strong)AVPlayer * player;
@property(nonatomic,strong)MPMoviePlayerController *mpc;
@property(nonatomic,assign)BOOL isPlay;
@end

@implementation videoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
//    NSString *playString = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
//    NSString * urlstr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *qurl = [NSURL URLWithString:urlstr];
//    //设置播放的项目
//    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:qurl];
//    //初始化player对象
//    self.player = [[AVPlayer alloc] initWithPlayerItem:item];
//    AVPlayerLayer * playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//    playerLayer.frame = CGRectMake(50, 100, 160, 90);
//    playerLayer.backgroundColor = [UIColor cyanColor].CGColor;
//    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
//    [self.view.layer addSublayer:playerLayer];
    
//    NSString *urlStr = @"http://7xawdc.com2.z0.glb.qiniucdn.com/o_19p6vdmi9148s16fs1ptehbm1vd59.mp4";
//    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url1 = [NSURL URLWithString:urlStr];
//    
//    MPMoviePlayerController * mpc = [[MPMoviePlayerController alloc] init];
//    mpc.contentURL = url1;//[NSURL URLWithString:url];
//    mpc.view.frame = CGRectMake(50, 100, 200, 100);
//    [self.view addSubview:mpc.view];
//    self.mpc = mpc;
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:@"http://www.colortu.com/upload/2016/09/18/17/201609181735316084.wav"]];
    
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    self.isPlay = !self.isPlay;
//    if (self.isPlay) {
//        [self.mpc play];
//    }else{
//        [self.mpc pause];
//    }
//
//}
//
//- (void)tapVideo{
//    self.isPlay = !self.isPlay;
//    if (self.isPlay) {
//        [self.mpc play];
//    }else{
//        [self.mpc stop];
//    }
//}



@end
