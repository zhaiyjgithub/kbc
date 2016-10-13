//
//  ShareTool.m
//  scanreader
//
//  Created by jbmac01 on 16/10/12.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "ShareTool.h"
#import <SVProgressHUD.h>

@implementation ShareTool

+ (void)show{
    SR_ShareView * shareView = [[SR_ShareView alloc] initShareViewWithBlock:^(NSInteger index) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        SSDKPlatformType platformType = SSDKPlatformTypeUnknown;
        [shareParams SSDKEnableUseClientShare]; //打开客户端分享
        if (index == 100) {//微信好友
            platformType = SSDKPlatformSubTypeWechatSession;
            [shareParams SSDKSetupWeChatParamsByText:@"定制微信的分享内容" title:@"title" url:[NSURL URLWithString:@"http://mob.com"] thumbImage:nil image:[UIImage imageNamed:@"传入的图片名"] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];// 微信好友子平台
        }else if (index == 101){//朋友圈
            platformType = SSDKPlatformSubTypeWechatTimeline;
            [shareParams SSDKSetupWeChatParamsByText:@"定制微信的分享内容" title:@"title" url:[NSURL URLWithString:@"http://mob.com"] thumbImage:nil image:[UIImage imageNamed:@"传入的图片名"] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
        }else if (index == 102) {//微博分享
            platformType = SSDKPlatformTypeSinaWeibo;
            [shareParams SSDKSetupSinaWeiboShareParamsByText:@"#阅友#" title:nil image:nil url:nil latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
        }
        [ShareSDK share:(platformType) parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            if (state == SSDKResponseStateSuccess) {
                [SVProgressHUD showInfoWithStatus:@"分享成功"];
            }else if (state == SSDKResponseStateFail){
                [SVProgressHUD showInfoWithStatus:@"分享失败"];
            }
        }];
    }];
    [shareView show];
}

+ (void)loginWithThirdAccountWithType:(SSDKPlatformType)platformType infoBlock:(loginInInfoBlock)infoBlock{
    [ShareSDK getUserInfo:platformType
        onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
       {
           if (state == SSDKResponseStateSuccess)
           {

               NSLog(@"uid=%@",user.uid);
               NSLog(@"%@",user.credential);
               NSLog(@"token=%@",user.credential.token);
               NSLog(@"nickname=%@",user.nickname);
               if (infoBlock) {
                   infoBlock(user);
               }
           }else{
               [SVProgressHUD setAnimationDuration:1.5];
               [SVProgressHUD showErrorWithStatus:@"授权登录失败"];
               NSLog(@"%@",error);
           }
           
       }];
}


@end
