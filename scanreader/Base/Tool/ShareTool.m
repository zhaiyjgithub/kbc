//
//  ShareTool.m
//  scanreader
//
//  Created by jbmac01 on 16/10/12.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "ShareTool.h"
#import <SVProgressHUD.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>


@implementation ShareTool

+ (void)show{
    SR_ShareView * shareView = [[SR_ShareView alloc] initShareViewWithBlock:^(NSInteger index) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        SSDKPlatformType platformType = SSDKPlatformTypeUnknown;
        [shareParams SSDKEnableUseClientShare]; //打开客户端分享
        if (index == 100) {//微信好友
            BOOL  isInstall =  [ShareSDK isClientInstalled:SSDKPlatformTypeWechat];
            if (!isInstall) {
                [SVProgressHUD setAnimationDuration:1.5];
                [SVProgressHUD showErrorWithStatus:@"当前还没有安装微信"];
            }
            platformType = SSDKPlatformSubTypeWechatSession;
            [shareParams SSDKSetupWeChatParamsByText:@"#阅友#" title:@"#阅友#" url:nil thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];// 微信好友子平台
        }else if (index == 101){//朋友圈
            BOOL  isInstall =  [ShareSDK isClientInstalled:SSDKPlatformTypeWechat];
            if (!isInstall) {
                [SVProgressHUD setAnimationDuration:1.5];
                [SVProgressHUD showErrorWithStatus:@"当前还没有安装微信"];
            }
            platformType = SSDKPlatformSubTypeWechatTimeline;
            [shareParams SSDKSetupWeChatParamsByText:@"#阅友#" title:@"#阅友#" url:nil thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
        }else if (index == 102) {//微博分享
            BOOL  isInstall =  [ShareSDK isClientInstalled:SSDKPlatformTypeSinaWeibo];
            if (!isInstall) {
                [SVProgressHUD setAnimationDuration:1.5];
                [SVProgressHUD showErrorWithStatus:@"当前还没有安装新浪微博"];
            }
            platformType = SSDKPlatformTypeSinaWeibo;
            [shareParams SSDKSetupSinaWeiboShareParamsByText:@"#阅友#" title:nil image:nil url:nil latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
        }else if (index == 103){//QQ
            BOOL  isInstall =  [ShareSDK isClientInstalled:SSDKPlatformTypeQQ];
            if (!isInstall) {
                [SVProgressHUD setAnimationDuration:1.5];
                [SVProgressHUD showErrorWithStatus:@"当前还没有安装QQ"];
            }
            platformType = SSDKPlatformTypeQQ;
            
            [shareParams SSDKSetupQQParamsByText:@"#阅友#" title:@"#阅友#" url:nil thumbImage:nil image:nil type:SSDKContentTypeAuto forPlatformSubType:(SSDKPlatformSubTypeQQFriend)];
        }else if (index == 104){//QQ zone
            BOOL  isInstall =  [ShareSDK isClientInstalled:SSDKPlatformTypeQQ];
            if (!isInstall) {
                [SVProgressHUD setAnimationDuration:1.5];
                [SVProgressHUD showErrorWithStatus:@"当前还没有安装QQ"];
            }
            platformType = SSDKPlatformSubTypeQZone;
            NSURL * url = [NSURL URLWithString:@"http://www.colortu.com"];
            UIImage * thumb = [UIImage imageNamed:@"shareImage.png"];
            
            [shareParams SSDKSetupQQParamsByText:@"阅友" title:@"阅友" url:url thumbImage:thumb image:thumb type:SSDKContentTypeAuto forPlatformSubType:(SSDKPlatformSubTypeQZone)];
            [shareParams SSDKSetupQQParamsByText:@"分享内容"
                                           title:@"图片"
                                             url:[NSURL URLWithString:@"http://mob.com"]
                                      thumbImage:thumb
                                           image:thumb
                                            type:SSDKContentTypeWebPage
                              forPlatformSubType:SSDKPlatformSubTypeQZone];
        }
        [ShareSDK share:(platformType) parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            if (state == SSDKResponseStateSuccess) {
                [SVProgressHUD showInfoWithStatus:@"分享成功"];
            }else if (state == SSDKResponseStateFail){
                [SVProgressHUD showInfoWithStatus:@"分享失败"];
                NSLog(@"share error:%@",error);
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
