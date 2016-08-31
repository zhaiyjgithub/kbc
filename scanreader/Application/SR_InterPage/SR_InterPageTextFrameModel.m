//
//  SR_InterPageTextFrameModel.m
//  scanreader
//
//  Created by jbmac01 on 16/8/31.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_InterPageTextFrameModel.h"
#import "globalHeader.h"
#import "requestAPI.h"
@implementation SR_InterPageTextFrameModel
- (void)setMoudleListItemModel:(SR_InterPageDetailItemMoudleListItemModel *)MoudleListItemModel{
    _MoudleListItemModel = MoudleListItemModel;
    //根据不同的类型来计算高度
    if ([MoudleListItemModel.type isEqualToString:PAGE_TYPY_7]) {//图片
        self.contentHeight = (280 + 10)*MoudleListItemModel.photoList.count;
    }else{
        CGSize contentSize = [MoudleListItemModel.content sizeForFont:[UIFont systemFontOfSize:14.0] size:CGSizeMake(kScreenWidth - 30, MAXFLOAT) mode:NSLineBreakByWordWrapping];
        self.contentHeight = (int)(contentSize.height < 40.0 ? 40 : contentSize.height + 1);
    }
}
@end
