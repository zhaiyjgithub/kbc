//
//  SR_FoundInterBtn.m
//  scanreader
//
//  Created by jbmac01 on 16/7/21.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_FoundInterBtn.h"

@implementation SR_FoundInterBtn
- (instancetype)initWithLength:(float)length{
    if (self=[super init]) {
        self.length = length;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, 17, 17);
    self.titleLabel.frame = CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width + 8, self.imageView.frame.origin.y, self.length - 17 - 8, 17);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont systemFontOfSize:12.0];
}


@end
