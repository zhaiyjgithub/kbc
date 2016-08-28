//
//  SR_MineMessageSendDialogMineSendViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/8/28.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_MineMessageSendDialogMineSendViewCell.h"
#import "globalHeader.h"
#import "NSDate+JJ.h"

@implementation SR_MineMessageSendDialogMineSendViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell{
    self.headerImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 48, 15, 48, 48)];
    self.headerImageView.backgroundColor = [UIColor redColor];
    self.headerImageView.userInteractionEnabled = YES;
    self.headerImageView.layer.cornerRadius = 24.0;
    self.headerImageView.layer.masksToBounds = YES;
    [self.headerImageView setImageWithURL:nil placeholder:[UIImage imageNamed:@"headerIcon"]];
    [self.contentView addSubview:self.headerImageView];
    
    self.messageLabel = [[SR_MessageDialogLabel alloc] initWithFrame:CGRectMake(15, self.headerImageView.frame.origin.y, kScreenWidth - 30 - 12 - self.headerImageView.frame.size.width, 100)];
    self.messageLabel.text = @"iOS隐藏tabBar的方法：设置self.tabBarController.tabBar.hidden=YES; 或者在push跳转时，设置self.hidesBottomBarWhenPushed=YES;";
    self.messageLabel.textColor = baseblackColor;
    self.messageLabel.layer.cornerRadius = 5.0;
    self.messageLabel.layer.masksToBounds = YES;
    self.messageLabel.textAlignment = NSTextAlignmentLeft;
    self.messageLabel.font = [UIFont systemFontOfSize:15.0];
    self.messageLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.messageLabel.numberOfLines = 0;
    [self.contentView addSubview:self.messageLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 120, self.messageLabel.frame.origin.y + self.messageLabel.frame.size.height + 5, 120, 14)];
    self.timeLabel.text = @"2016-09-12 12:00";
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.timeLabel];
}

- (void)setFrameModel:(SR_MineMessageFrameModel *)frameModel{
    _frameModel = frameModel;
    [self.headerImageView setImageWithURL:[NSURL URLWithString:frameModel.messageModel.sender.avatar] placeholder:[UIImage imageNamed:@"headerIcon"]];
    CGFloat width = frameModel.cellMessageLableSize.width + 10 > ( kScreenWidth - 30 - 12 - 48) ?  (kScreenWidth - 30 - 12 - 48) : (frameModel.cellMessageLableSize.width + 10);
    self.messageLabel.frame = CGRectMake(self.headerImageView.frame.origin.x - width - 12, 15, width, frameModel.cellMessageLableSize.height + 15);
    self.messageLabel.text = frameModel.messageModel.content;
    NSDate * createData = [NSDate dateWithTimeIntervalSince1970:frameModel.messageModel.time_create];
    NSString * time = [NSDate getRealDateTime:createData withFormat:@"yyyy-MM-dd HH:mm"];
    self.timeLabel.text = time;
    
    self.timeLabel.frame = CGRectMake(15, self.messageLabel.frame.origin.y + self.messageLabel.frame.size.height + 5, 120, 14);
}


@end
