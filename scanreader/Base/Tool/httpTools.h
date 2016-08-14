//
//  httpTools.h
//  scanreader
//
//  Created by jbmac01 on 16/8/9.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <Foundation/Foundation.h>
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
@end
