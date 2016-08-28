//
//  SR_MineMessageFrameModel.m
//  scanreader
//
//  Created by jbmac01 on 16/8/28.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_MineMessageFrameModel.h"
#import "NSString+JJ.h"

@implementation SR_MineMessageFrameModel

- (void)setMessageModel:(SR_MineMessageModel *)messageModel{
    _messageModel = messageModel;
    CGSize size = [messageModel.content sizeForFont:[UIFont systemFontOfSize:16.0] size:CGSizeMake(kScreenWidth - 30 - 12 - 48, MAXFLOAT) mode:(NSLineBreakByWordWrapping)];
    self.cellMessageLableSize = CGSizeMake((int)size.width, (int)size.height);
}

@end
