//
//  SR_InterPageListModel.h
//  scanreader
//
//  Created by jbmac01 on 16/8/30.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_BaseModel.h"

@interface SR_InterPageListModel : SR_BaseModel
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * pageId;
@property(nonatomic,copy)NSString * member_total;
@property(nonatomic,copy)NSString * note_total;
@property(nonatomic,copy)NSString * picture;
@property(nonatomic,assign)NSInteger time_create;
@property(nonatomic,copy)NSString * title;
@end
