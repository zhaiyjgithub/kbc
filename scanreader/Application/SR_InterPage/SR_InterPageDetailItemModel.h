//
//  SR_InterPageDetailItemModel.h
//  scanreader
//
//  Created by jbmac01 on 16/8/30.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_BaseModel.h"

@interface SR_InterPageDetailItemBookModel : SR_BaseModel
@property(nonatomic,copy)NSString * author;
@property(nonatomic,copy)NSString * company;
@property(nonatomic,copy)NSString * book_id;
@property(nonatomic,copy)NSString * picture;
@property(nonatomic,copy)NSString * publisher;
@property(nonatomic,copy)NSString * title;
@end

@interface SR_InterPageDetailItemMoudleListItemModel : SR_BaseModel
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * field1;
@property(nonatomic,copy)NSString * field2;
@property(nonatomic,copy)NSString * moduleItemId;
@property(nonatomic,copy)NSArray * itemList;
@property(nonatomic,copy)NSString * page_id;
@property(nonatomic,copy)NSArray * photoList;
@property(nonatomic,copy)NSString * picture;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * type;
@end

@interface SR_InterPageDetailItemMoudleListItemPhotoListItemModel : SR_BaseModel
@property(nonatomic,copy)NSString * photoModelId;
@property(nonatomic,copy)NSString * pic;
@property(nonatomic,copy)NSString * picture;
@property(nonatomic,copy)NSString * sort;
@property(nonatomic,assign)NSInteger time_create;
@property(nonatomic,assign)NSInteger time_update;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * url;
@end

@interface SR_InterPageDetailItemModel : SR_BaseModel
@property(nonatomic,strong)SR_InterPageDetailItemBookModel * book;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * modelDescription;
@property(nonatomic,copy)NSString * member_total;
@property(nonatomic,copy)NSArray *  moduleList;
@property(nonatomic,copy)NSString * note_total;
@property(nonatomic,copy)NSString * picture;
@property(nonatomic,copy)NSString * title;
@end
