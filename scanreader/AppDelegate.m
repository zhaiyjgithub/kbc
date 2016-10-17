//
//  AppDelegate.m
//  scanreader
//
//  Created by jbmac01 on 16/7/12.
//  Copyright © 2016年 jb. All rights reserved.
//
        
#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WeiboSDK.h"
#import "WXApi.h"
#import "SR_TabbarViewController.h"
#import "SR_LoginViewController.h"
#import "httpTools.h"
#import "SVProgressHUD.h"
#import "UserInfo.h"
#import "globalHeader.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];

    NSString * phoneNumber = [UserInfo getUserPhoneNumber];
    NSString * password = [UserInfo getUserPassword];
    NSString * userId = [UserInfo getUserId];
    NSString * token = [UserInfo getUserToken];
    if (!phoneNumber.length || !password.length || !userId.length || !token.length) {
        SR_LoginViewController * loginVC = [[SR_LoginViewController alloc] init];
        self.window.rootViewController = loginVC;
    }else{
        self.window.rootViewController = [[SR_TabbarViewController alloc] init];
    }
    [self setNavigationBarStyle];
    
    /*
        记得上下的全部参数都要设置完整
     */
    [ShareSDK registerApp:@"14cd112af4f4c"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            ]
                 onImport:^(SSDKPlatformType platformType){
         switch (platformType){
            case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
            case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
            case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
                 
            default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo){
         
         switch (platformType){
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 //如果出现跳转授权失败，一般都是新浪开发平台的bundleid与当前项目的不匹配
                 //授权失败可能就是重定向的url出错
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"806727643"
                                           appSecret:@"ba0611c3bcb1b02a860a40faeef50e17"
                                         redirectUri:@"http://www.colortu.com"
                                            authType:SSDKAuthTypeBoth];
                 break;
            case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx6706a006d4324d73" appSecret:@"4d673f73665034a90c857cd313f7f286"];
                 break;
            
            case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105683125" appKey:@"XIsOgGmb3zVhLRPL" authType:SSDKAuthTypeBoth];
                 break;
                    default:
                 break;
         }
     }];

    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setNavigationBarStyle{
    [UINavigationBar appearance].barTintColor = [UIColor blackColor];
    [UINavigationBar appearance].barStyle = UIBarStyleBlack;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

@end
