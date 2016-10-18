//
//  ShareTool.h
//  scanreader
//
//  Created by jbmac01 on 16/10/12.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import "WeiboSDK.h"
#import "SR_ShareView.h"

typedef void(^loginInInfoBlock)(SSDKUser * user,BOOL isNewAuthorized);

@interface ShareTool : NSObject
@property(nonatomic,strong)loginInInfoBlock infoBlock;
+ (void)show;
+ (void)loginWithThirdAccountWithType:(SSDKPlatformType)platformType infoBlock:(loginInInfoBlock)infoBlock;
@end
