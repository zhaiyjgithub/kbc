//
//  SR_BaseModel.m
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_BaseModel.h"

@implementation SR_BaseModel
+(LKDBHelper *)getUsingLKDBHelper
{
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* dbpath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/sr.sqlite"];
        //NSLog(@"路径:%@",dbpath);
        db = [[LKDBHelper alloc]initWithDBPath:dbpath];
        //or
        //        db = [[LKDBHelper alloc]init];
    });
    return db;
}
@end
