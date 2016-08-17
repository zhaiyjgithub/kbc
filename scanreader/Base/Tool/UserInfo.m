//
//  UserInfo.m
//  scanreader
//
//  Created by jbmac01 on 16/8/14.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "UserInfo.h"

#define USER_AVATAR @"avatar"
#define USER_ID     @"userId"
#define USER_TOKEN  @"userToken"
#define USER_NAME   @"userName"
#define USER_PHONENUMBER @"userPhoneNumber"
#define USER_PASSWORD @"userPhoneWord"

@implementation UserInfo

+(void)saveUserAvatarWith:(NSString *)avatar{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:avatar forKey:USER_AVATAR];
    [defaults synchronize];
}

+(void)saveUserIDWith:(NSString *)userId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userId forKey:USER_ID];
    [defaults synchronize];
}

+(void)saveUserTokenWith:(NSString *)token{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:USER_TOKEN];
    [defaults synchronize];
}

+(void)saveUserNameWith:(NSString *)name{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:name forKey:USER_NAME];
    [defaults synchronize];
}

+(void)saveUserPhoneNumberWith:(NSString *)phoneNumber{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:phoneNumber forKey:USER_PHONENUMBER];
    [defaults synchronize];
}

+(void)saveUserPasswordWith:(NSString *)password{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:password forKey:USER_PASSWORD];
    [defaults synchronize];
}


+(NSString *)getUserAvatar{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [defaults objectForKey:USER_AVATAR];
    return string;
}

+(NSString *)getUserId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [defaults objectForKey:USER_ID];
    return string;
}

+(NSString *)getUserToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [defaults objectForKey:USER_TOKEN];
    return string;
}

+(NSString *)getUserName{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [defaults objectForKey:USER_NAME];
    return string;
}

+(NSString *)getUserPhoneNumber{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [defaults objectForKey:USER_PHONENUMBER];
    return string;
}

+(NSString *)getUserPassword{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [defaults objectForKey:USER_PASSWORD];
    return string;
}



@end
