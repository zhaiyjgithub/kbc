//
//  httpTools.h
//  scanreader
//
//  Created by jbmac01 on 16/8/9.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RequestAPI.h"

@interface httpTools : NSObject
+ (void)post:(NSString *)url
andParameters:(NSDictionary *)parameters
     success:(void (^)(NSDictionary *dic))success
     failure:(void (^)(NSError *error))failure;
+ (void)get:(NSString *)url
andParameters:(NSDictionary *)parameters
    success:(void (^)(NSDictionary *dic))success
    failure:(void (^)(NSError *error))failure;
+ (void)uploadImage:(NSString *)url parameters:(NSDictionary *)parameters images:(NSArray *)images
            success:(void (^)(NSDictionary *dic))success
            failure:(void (^)(NSError *error))failure;
+ (void)uploadVoice:(NSString *)url parameters:(NSDictionary *)parameters voicesUrl:(NSArray *)voicesUrl
            success:(void (^)(NSDictionary *dic))success
            failure:(void (^)(NSError *error))failure;
+ (void)uploadHeaderImage:(NSString *)url parameters:(NSDictionary *)parameters images:(NSArray *)images
                     file:(NSString *)file
                  success:(void (^)(NSDictionary *dic))success
                  failure:(void (^)(NSError *error))failure;

@end
