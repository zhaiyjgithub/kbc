//
//  SR_MineMessageListViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/7/22.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_MineMessageListViewCell.h"
#import "globalHeader.h"

@implementation SR_MineMessageListViewCell

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
    
    self.hub = [[RKNotificationHub alloc] initWithView:self.headerImageView];
    [self.hub setCount:10];
    [self.hub setCircleAtFrame:CGRectMake(35, -5, 20, 20)];
    [self.hub setCircleColor:baseColor labelColor:[UIColor whiteColor]];

    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeaderImageView)];
    [self.headerImageView addGestureRecognizer:gesture];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headerImageView.frame.origin.x + self.headerImageView.frame.size.width + 10, self.headerImageView.center.y - 8, 100, 16)];
    self.nameLabel.text = @"刘备";
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.textColor = baseblackColor;
    self.nameLabel.font = [UIFont systemFontOfSize:15.0];
    self.nameLabel.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.nameLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 30 - 120, self.nameLabel.frame.origin.y, 120, 16)];
    self.timeLabel.text = @"2016-09-12 12：00";
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.timeLabel];
    
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.headerImageView.frame.origin.y + self.frame.size.height + 15, kScreenWidth - 45, 16)];
    self.messageLabel.text = @"imeLabel = [[UILabel alloc] initWithFrame:CGRectMak";
    self.messageLabel.textColor = [UIColor lightGrayColor];
    self.messageLabel.font = [UIFont systemFontOfSize:14.0];
    self.messageLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.messageLabel];
    
}

- (void)clickHeaderImageView{
    SSLog(@"click header iamge");
}

@end
