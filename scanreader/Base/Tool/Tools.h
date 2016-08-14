//
//  Tools.h
//  scanreader
//
//  Created by admin on 16/7/23.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject
+ (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key;
+ (NSString *)getRadomCode:(NSInteger)length;
+ (NSString *)appendEqualSign:(NSString *)s;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
