//
//  SR_MessageDialogLabel.m
//  scanreader
//
//  Created by jbmac01 on 16/7/22.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_MessageDialogLabel.h"

@implementation SR_MessageDialogLabel

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    size.width  += self.edgeInsets.left + self.edgeInsets.right;
    size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return size;
}

@end
