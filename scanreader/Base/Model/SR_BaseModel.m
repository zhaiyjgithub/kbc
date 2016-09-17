//
//  SR_BaseModel.m
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_BaseModel.h"
#import "UserInfo.h"

@implementation SR_BaseModel
+(LKDBHelper *)getUsingLKDBHelper{
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString * userId = [UserInfo getUserId];
        NSString * sqlName = [NSString stringWithFormat:@"Documents/sr-%@.sqlite",userId];
        NSString* dbpath = [NSHomeDirectory() stringByAppendingPathComponent:sqlName];
        NSLog(@"路径:%@",dbpath);
        db = [[LKDBHelper alloc]initWithDBPath:dbpath];
    });
    return db;
}
@end
