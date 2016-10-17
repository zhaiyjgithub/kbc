//
//  SR_MineMessageListViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/7/22.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_MineMessageListViewCell.h"
#import "globalHeader.h"
#import "NSDate+JJ.h"

@implementation SR_MineMessageListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell{
    self.headerImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(15, 15, 48, 48)];
    self.headerImageView.backgroundColor = [UIColor whiteColor];
    self.headerImageView.userInteractionEnabled = YES;
    self.headerImageView.layer.cornerRadius = 24.0;
    self.headerImageView.layer.masksToBounds = YES;
    [self.headerImageView setImageWithURL:nil placeholder:[UIImage imageNamed:@"headerIcon"]];
    [self.contentView addSubview:self.headerImageView];
    
    UIView * tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
    tmpView.center = CGPointMake(self.headerImageView.frame.origin.x + 48 , self.headerImageView.frame.origin.y);
    tmpView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:tmpView];
    self.hub = [[RKNotificationHub alloc] initWithView:tmpView];
    [self.hub setCount:10];
    [self.hub setCircleAtFrame:CGRectMake(-10, - 4, 20, 20)];
    [self.hub setCircleColor:baseColor labelColor:[UIColor whiteColor]];

    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeaderImageView)];
    [self.headerImageView addGestureRecognizer:gesture];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headerImageView.frame.origin.x + self.headerImageView.frame.size.width + 10, self.headerImageView.center.y - 8, 100, 16)];
    self.nameLabel.text = @"--";
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.textColor = baseblackColor;
    self.nameLabel.font = [UIFont systemFontOfSize:15.0];
    self.nameLabel.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.nameLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 30 - 120, self.nameLabel.frame.origin.y, 120, 16)];
    self.timeLabel.text = @"--";
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.timeLabel];
    
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.headerImageView.frame.origin.y + self.frame.size.height + 15, kScreenWidth - 45, 16)];
    self.messageLabel.text = @"...";
    self.messageLabel.textColor = [UIColor lightGrayColor];
    self.messageLabel.font = [UIFont systemFontOfSize:14.0];
    self.messageLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.messageLabel];
    
}

- (void)setMessageModel:(SR_MineMessageModel *)messageModel{
    _messageModel = messageModel;
    [self.hub setCount:[messageModel.readed intValue]];
        [self.headerImageView setImageWithURL:[NSURL URLWithString:messageModel.sender.avatar] placeholder:[UIImage imageNamed:@"headerIcon"]];
    NSDate * createData = [NSDate dateWithTimeIntervalSince1970:messageModel.time_create];
    NSString * time = [NSDate compareCurrentTime:createData];//[NSDate getRealDateTime:createData withFormat:@"yyyy-MM-dd HH:mm"];
    self.timeLabel.text = time;
    self.messageLabel.text = messageModel.content;
    self.nameLabel.text = messageModel.sender.username;
    
    [self.hub setCount:self.unreadMessageCount];
    [self.hub pop];
}

- (void)clickHeaderImageView{
    SSLog(@"click header iamge");
}

@end
