//
//  SR_MineMessagePeopleModel.h
//  scanreader
//
//  Created by zack on 2016/12/10.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_BaseModel.h"
#import "SR_MineMessageModel.h"

@interface SR_MineMessagePeopleModel : SR_BaseModel
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * create_by;
@property(nonatomic,copy)NSString * message_id;
@property(nonatomic,copy)NSString * readed;
@property(nonatomic,strong)Sender * sender;
@property(nonatomic,copy)NSString * target_type;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,assign)NSInteger time_create;
@property(nonatomic,copy)NSString * url;
@end
