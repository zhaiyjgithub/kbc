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
#define USER_LEVEL @"userLevel"
#define USER_CREDIT @"userCredit"
#define USER_IS_PUBLIC @"userIsPulic"

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

+(void)saveUserLevelWith:(NSString *)level{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:level forKey:USER_LEVEL];
    [defaults synchronize];
}

+(void)saveUserCreditWith:(NSString *)credit{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:credit forKey:USER_CREDIT];
    [defaults synchronize];
}

+(void)saveUserPublicWith:(NSString *)isPublic{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:isPublic forKey:USER_IS_PUBLIC];
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

+(NSString *)getUserLevel{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [defaults objectForKey:USER_LEVEL];
    return string;
}

+(NSString *)getUserCredit{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [defaults objectForKey:USER_CREDIT];
    return string;
}

+(NSString *)getUserPublic{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [defaults objectForKey:USER_IS_PUBLIC];
    return string;
}



@end
