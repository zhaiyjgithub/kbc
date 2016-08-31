//
//  SR_InterPageTextFrameModel.h
//  scanreader
//
//  Created by jbmac01 on 16/8/31.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SR_InterPageDetailItemModel.h"
@interface SR_InterPageTextFrameModel : NSObject
@property(nonatomic,strong)SR_InterPageDetailItemMoudleListItemModel * MoudleListItemModel;
@property(nonatomic,assign)CGFloat contentHeight;
@end
