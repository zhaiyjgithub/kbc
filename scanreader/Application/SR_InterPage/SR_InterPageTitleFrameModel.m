//
//  SR_InterPageTitleFrameModel.m
//  scanreader
//
//  Created by jbmac01 on 16/8/30.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_InterPageTitleFrameModel.h"
#import "NSString+JJ.h"
#import "globalHeader.h"

@implementation SR_InterPageTitleFrameModel

- (void)setDetailItemModel:(SR_InterPageDetailItemModel *)detailItemModel{
    _detailItemModel = detailItemModel;
    CGSize contentSize = [detailItemModel.content sizeForFont:[UIFont systemFontOfSize:14.0] size:CGSizeMake(kScreenWidth - 30, MAXFLOAT) mode:NSLineBreakByWordWrapping];
    self.contentHeight = (int)(contentSize.height < 40.0 ? 40 : contentSize.height + 1);
}

@end
