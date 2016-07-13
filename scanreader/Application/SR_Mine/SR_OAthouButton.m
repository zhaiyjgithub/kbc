//
//  SR_OAthouButton.m
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_OAthouButton.h"

@implementation SR_OAthouButton

- (instancetype)initWithType:(BaseButtonType)type sizeType:(BaseButtonSizeType)sizeType{
    if (self=[super init]) {
        self.type = type;
        self.sizeType = sizeType;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.type == BaseButtonTypeLeft) {
        CGFloat d = 10;
        if (self.sizeType == BaseButtonSizeTypeLarge) {
            d = 20;
        }
        self.imageView.frame = CGRectMake(0, 0, 16, 16);
        self.titleLabel.frame = CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width + d, self.imageView.frame.origin.y, 56, 16);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    }
}

@end
