//
//  SR_InterPageTitleFrameModel.h
//  scanreader
//
//  Created by jbmac01 on 16/8/30.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SR_InterPageDetailItemModel.h"
@interface SR_InterPageTitleFrameModel : NSObject
@property(nonatomic,strong)SR_InterPageDetailItemModel * detailItemModel;
@property(nonatomic,copy)NSString * type;
@property(nonatomic,assign)CGFloat contentHeight;
@end
