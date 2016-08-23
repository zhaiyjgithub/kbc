//
//  SR_BookClubMarkModel.h
//  scanreader
//
//  Created by jbmac01 on 16/8/17.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_BaseModel.h"
#import <YYKit/YYKit.h>
@interface SR_BookClubNoteResourceModel : NSObject
@property(nonatomic,copy)NSString * resource_id;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * url;
@property(nonatomic,copy)NSString * path;
@property(nonatomic,copy)NSString * type;
@end

@interface SR_BookClubNoteBookModel : NSObject
@property(nonatomic,copy)NSString * book_id;
@property(nonatomic,copy)NSString * member_total;
@property(nonatomic,copy)NSString * note_total;
@property(nonatomic,copy)NSString * title;
@end

@interface SR_BookClubNoteUserModel : NSObject
@property(nonatomic,copy)NSString * avatar;
@property(nonatomic,copy)NSString * user_id;
@property(nonatomic,copy)NSString * username;
@end

@interface SR_BookClubBookNoteModel : SR_BaseModel
@property(nonatomic,copy)NSString * note_id;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * type;
@property(nonatomic,assign)NSInteger time_create;
@property(nonatomic,copy)NSString * note_total;
@property(nonatomic,copy)NSString * member_total;
@property(nonatomic,strong)SR_BookClubNoteUserModel * user;
@property(nonatomic,strong)SR_BookClubNoteBookModel * book;
@property(nonatomic,copy)NSString * page;
@property(nonatomic,copy)NSArray * resourceList;
@end
