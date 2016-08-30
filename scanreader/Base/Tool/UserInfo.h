//
//  UserInfo.h
//  scanreader
//
//  Created by jbmac01 on 16/8/14.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
+(void)saveUserAvatarWith:(NSString *)avatar;
+(void)saveUserIDWith:(NSString *)userId;
+(void)saveUserTokenWith:(NSString *)token;
+(void)saveUserNameWith:(NSString *)name;
+(void)saveUserPhoneNumberWith:(NSString *)phoneNumber;
+(void)saveUserPasswordWith:(NSString *)password;
+(void)saveUserLevelWith:(NSString *)level;
+(void)saveUserCreditWith:(NSString *)credit;
+(NSString *)getUserAvatar;
+(NSString *)getUserId;
+(NSString *)getUserToken;
+(NSString *)getUserName;
+(NSString *)getUserPhoneNumber;
+(NSString *)getUserPassword;
+(NSString *)getUserLevel;
+(NSString *)getUserCredit;
@end
