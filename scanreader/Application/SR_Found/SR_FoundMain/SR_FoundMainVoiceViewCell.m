//
//  SR_FoundMainVoiceViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_FoundMainVoiceViewCell.h"
#import "globalHeader.h"

@implementation SR_FoundMainVoiceViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 125, 16)];
    self.titleLabel.text = @"笔记标题";
    self.titleLabel.font = [UIFont systemFontOfSize:16.0];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 15,15,120,16)];
    self.timeLabel.text = @"2016-06-28 12:30";
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.timeLabel];
    
    self.voiceBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.voiceBtn.frame = CGRectMake(15, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 10, 200, 30);
    self.voiceBtn.backgroundColor = [UIColor redColor];
    self.voiceBtn.layer.cornerRadius = 15.0;
    [self.voiceBtn addTarget:self action:@selector(clickVoiceBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.voiceBtn setTitle:@"12s" forState:(UIControlStateNormal)];
    self.voiceBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.voiceBtn];
    
    self.subtitleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.voiceBtn.frame.origin.y + self.voiceBtn.frame.size.height + 10, 16, 16)];
    self.subtitleImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.subtitleImageView];
    
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.subtitleImageView.frame.origin.x + self.subtitleImageView.frame.size.width + 5, self.subtitleImageView.frame.origin.y, 215, 16)];
    self.subtitleLabel.text = @"《论语》第二十页";
    self.subtitleLabel.textColor = [UIColor blackColor];
    self.subtitleLabel.textAlignment = NSTextAlignmentLeft;
    self.subtitleLabel.font = [UIFont systemFontOfSize:16.0];
    [self.contentView addSubview:self.subtitleLabel];
    
    self.messageAndMembersLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.subtitleLabel.frame.origin.x, self.subtitleLabel.frame.origin.y + self.subtitleLabel.frame.size.height + 12, 215, 14)];
    self.messageAndMembersLabel.text = @"互动信息(20)  读书会成员(85)";
    self.messageAndMembersLabel.textColor = [UIColor lightGrayColor];
    self.messageAndMembersLabel.textAlignment = NSTextAlignmentLeft;
    self.messageAndMembersLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.messageAndMembersLabel];
    
    self.headerBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.headerBtn.frame = CGRectMake(0, 0, 48, 48);
    self.headerBtn.center = CGPointMake(kScreenWidth - 36, 62);
    self.headerBtn.layer.cornerRadius = 24;
    self.headerBtn.backgroundColor = [UIColor redColor];
    [self.headerBtn addTarget:self action:@selector(clickHeaderBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:self.headerBtn];
    
}

- (void)clickVoiceBtn{
    SSLog(@"click voice btn");
}


@end
