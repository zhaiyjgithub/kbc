//
//  SR_BookClubBookModel.h
//  scanreader
//
//  Created by jbmac01 on 16/8/16.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_BaseModel.h"
@interface SR_BookClubBookModel : SR_BaseModel
@property(nonatomic,copy)NSString * author;
@property(nonatomic,copy)NSString * barcode;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * edition;
@property(nonatomic,copy)NSString * book_id;
@property(nonatomic,copy)NSString * isbn;
@property(nonatomic,copy)NSString * member_total;
@property(nonatomic,copy)NSString * note_total;
@property(nonatomic,copy)NSString * picture;
@property(nonatomic,copy)NSString * price;
@property(nonatomic,copy)NSString * publisher;
@property(nonatomic,copy)NSString * qrcode;
@property(nonatomic,copy)NSString * time_create;
@property(nonatomic,copy)NSString * time_publish;
@property(nonatomic,copy)NSString * title;
@end
