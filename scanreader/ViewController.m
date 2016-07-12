//
//  ViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/12.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "ViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Home";
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 50, 50)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"login" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(login) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    UIButton * share = [[UIButton alloc] initWithFrame:CGRectMake(50, 200, 60, 60)];
    share.backgroundColor = [UIColor blueColor];
    [share setTitle:@"share" forState:(UIControlStateNormal)];
    [share addTarget:self action:@selector(clickBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:share];
                
}

- (void)clickBtn{
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"buy_dot.png"]];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                     images:imageArray
                                        url:[NSURL URLWithString:@"http://mob.com"]
                                      title:@"分享标题"
                                       type:SSDKContentTypeAuto];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        NSLog(@"state:%d",state);
        
    }];
}

- (void)login{
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];
}




@end
