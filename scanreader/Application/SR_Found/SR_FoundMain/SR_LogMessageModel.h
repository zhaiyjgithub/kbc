//
//  SR_LogMessageModel.h
//  scanreader
//
//  Created by jbmac01 on 16/9/26.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_BaseModel.h"

@interface SR_LogMessageModel : SR_BaseModel
@property(nonatomic,copy)NSString * avatar;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * logMessage_id;
@property(nonatomic,copy)NSString * target_id;
@property(nonatomic,copy)NSString * target_type;
@property(nonatomic,assign)NSInteger time_create;
@property(nonatomic,copy)NSString * url;
@property(nonatomic,copy)NSString * user_id;
@property(nonatomic,copy)NSString * username;
@end
