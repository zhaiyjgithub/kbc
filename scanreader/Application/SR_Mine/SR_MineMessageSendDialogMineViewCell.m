//
//  SR_MineMessageSendDialogViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/7/22.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_MineMessageSendDialogMineViewCell.h"
#import "globalHeader.h"

@implementation SR_MineMessageSendDialogMineViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell{
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 48, 48)];
    self.headerImageView.backgroundColor = [UIColor redColor];
    self.headerImageView.userInteractionEnabled = YES;
    self.headerImageView.layer.cornerRadius = 24.0;
    [self.contentView addSubview:self.headerImageView];
    
    self.messageLabel = [[SR_MessageDialogLabel alloc] initWithFrame:CGRectMake(self.headerImageView.frame.origin.x + self.headerImageView.frame.size.width + 12, self.headerImageView.frame.origin.y, kScreenWidth - 30 - 12 - self.headerImageView.frame.size.width, 100)];
    self.messageLabel.text = @"iOS隐藏tabBar的方法：设置self.tabBarController.tabBar.hidden=YES; 或者在push跳转时，设置self.hidesBottomBarWhenPushed=YES;";
    self.messageLabel.textColor = baseblackColor;
    self.messageLabel.layer.cornerRadius = 3.0;
    self.messageLabel.clipsToBounds = YES;
    self.messageLabel.textAlignment = NSTextAlignmentLeft;
    self.messageLabel.font = [UIFont systemFontOfSize:15.0];
    self.messageLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.messageLabel.numberOfLines = 0;
    [self.contentView addSubview:self.messageLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 120, self.messageLabel.frame.origin.y + self.messageLabel.frame.size.height + 5, 120, 14)];
    self.timeLabel.text = @"2016-09-12 12:00";
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.timeLabel];
}

@end
