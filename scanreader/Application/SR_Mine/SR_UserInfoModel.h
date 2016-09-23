//
//  SR_UserInfoModel.h
//  scanreader
//
//  Created by jbmac01 on 16/9/23.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_BaseModel.h"

@interface SR_UserInfoModel : SR_BaseModel
@property(nonatomic,copy)NSString * avatar;
@property(nonatomic,copy)NSString * credit;
@property(nonatomic,copy)NSString * user_id;
@property(nonatomic,copy)NSString * level;
@property(nonatomic,assign)NSInteger time_create;
@property(nonatomic,copy)NSString * username;
@end
