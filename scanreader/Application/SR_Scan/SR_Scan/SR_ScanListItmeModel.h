//
//  SR_ScanListItmeModel.h
//  scanreader
//
//  Created by jbmac01 on 16/10/17.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_BaseModel.h"

@interface SR_ScanListItmeModel : SR_BaseModel
@property(nonatomic,copy)NSString * modelId;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * url;
@property(nonatomic,copy)NSString * target_type;
@property(nonatomic,copy)NSString * target_id;
@property(nonatomic,assign)NSInteger time_create;
@end
