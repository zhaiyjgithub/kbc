//
//  SR_RecordMainTagButton.m
//  scanreader
//
//  Created by jbmac01 on 16/7/21.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_RecordMainTagButton.h"

@implementation SR_RecordMainTagButton

- (instancetype)initWithLength:(float)width height:(CGFloat)height{
    if (self=[super init]) {
        self.width = width;
        self.height = height;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat leftBorder = self.width - 19 - 10 - 50;
    self.imageView.frame = CGRectMake(leftBorder, (self.height - 19)/2, 19, 19);
    self.titleLabel.frame = CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width + 10, self.imageView.frame.origin.y, 50, 17);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont systemFontOfSize:16.0];
}


@end
