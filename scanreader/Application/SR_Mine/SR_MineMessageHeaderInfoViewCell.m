//
//  SR_MineMessageHeaderInfoViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/7/14.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_MineMessageHeaderInfoViewCell.h"
#import "globalHeader.h"

@implementation SR_MineMessageHeaderInfoViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell{
    self.headerIcon = [[UIImageView alloc] init];
    self.headerIcon.frame = CGRectMake(15, 10, 48, 48);
    self.headerIcon.layer.cornerRadius = 24;
    self.headerIcon.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.headerIcon];
    self.headerIcon.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickheaderIcon)];
    [self.headerIcon addGestureRecognizer:gesture];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.frame = CGRectMake(0, 0, kScreenWidth - 30 - 48 - 10, 16);
    self.nameLabel.center = CGPointMake(self.headerIcon.frame.origin.x + self.headerIcon.frame.size.width + 10 + self.nameLabel.frame.size.width/2, self.headerIcon.center.y);
    self.nameLabel.text = @"用户名称: 小明";
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.font = [UIFont systemFontOfSize:16.0];
    [self.contentView addSubview:self.nameLabel];
}

- (void)clickheaderIcon{
    if (self.block) {
        self.block();
    }
}

- (void)addBlock:(mineMessageHeaderInfoViewCellBlock)block{
    self.block = block;
}

@end
