//
//  SR_MineMessageModel.h
//  scanreader
//
//  Created by jbmac01 on 16/8/24.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_BaseModel.h"

@interface Sender : SR_BaseModel
@property(nonatomic,copy)NSString * avatar;
@property(nonatomic,copy)NSString * sender_id;
@property(nonatomic,copy)NSString * username;
@end

@interface Recipient : SR_BaseModel
@property(nonatomic,copy)NSString * avatar;
@property(nonatomic,copy)NSString * recipient_id;
@property(nonatomic,copy)NSString * username;
@end

@interface Target : SR_BaseModel
@property(nonatomic,copy)NSString * target_id;
@property(nonatomic,copy)NSString * picture;
@property(nonatomic,copy)NSString * title;
@end

@interface SR_MineMessageModel : SR_BaseModel
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * create_by;
@property(nonatomic,copy)NSString * message_id;
@property(nonatomic,copy)NSString * readed;
@property(nonatomic,strong)Sender * sender;
@property(nonatomic,strong)Recipient * recipient;
@property(nonatomic,copy)NSString * sender_id;
@property(nonatomic,strong)Target * target;
@property(nonatomic,copy)NSString * target_type;
@property(nonatomic,copy)NSString * type;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,assign)NSInteger time_create;
@property(nonatomic,copy)NSString * url;
@property(nonatomic,assign)BOOL isMyAccount;//区分自己的还是他人的消息
@end
