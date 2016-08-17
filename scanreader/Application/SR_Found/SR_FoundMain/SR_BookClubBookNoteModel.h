//
//  SR_BookClubMarkModel.h
//  scanreader
//
//  Created by jbmac01 on 16/8/17.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_BaseModel.h"

@interface SR_BookClubNoteResourceModel : SR_BaseModel
@property(nonatomic,copy)NSString * resource_id;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * url;
@property(nonatomic,copy)NSString * path;
@property(nonatomic,copy)NSString * type;
@end

@interface SR_BookClubBookNoteModel : SR_BaseModel
@property(nonatomic,copy)NSString * note_id;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * type;
@property(nonatomic,copy)NSString * time_create;
@property(nonatomic,copy)NSString * note_total;
@property(nonatomic,copy)NSString * member_total;
@property(nonatomic,copy)NSString * user;
@property(nonatomic,copy)NSString * book;
@property(nonatomic,copy)NSString * page;
@property(nonatomic,copy)NSArray * resourceList;
@end
