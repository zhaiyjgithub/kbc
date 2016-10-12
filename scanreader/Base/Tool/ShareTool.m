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
        [shareParams SSDKEnableUseClientShare]; //打开客户端分享
        
        SSDKPlatformType platformType = SSDKPlatformTypeUnknown;
        if (index == 102) {//微博分享
            platformType = SSDKPlatformTypeSinaWeibo;
            [shareParams SSDKSetupSinaWeiboShareParamsByText:@"#阅友#" title:nil image:nil url:nil latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
            [ShareSDK share:(platformType) parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                if (state == SSDKResponseStateSuccess) {
                    [SVProgressHUD showInfoWithStatus:@"分享成功"];
                }else if (state == SSDKResponseStateFail){
                    [SVProgressHUD showInfoWithStatus:@"分享失败"];
                }
            }];
        }
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
