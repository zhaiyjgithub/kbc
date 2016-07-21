//
//  SR_FoundMainImageSelfViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/7/21.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_FoundMainImageSelfViewCell.h"
#import "globalHeader.h"

@implementation SR_FoundMainImageSelfViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 125, 15)];
    self.titleLabel.text = @"笔记标题";
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 15,15,120,16)];
    self.timeLabel.text = @"2016-06-28 12:30";
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.timeLabel];
    
    self.recordImageView = [[UIImageView alloc] init];
    self.recordImageView.frame = CGRectMake(18, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 8, 75, 39);
    self.recordImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.recordImageView];
    
    UIImageView * messageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.recordImageView.frame.origin.y + self.recordImageView.frame.size.height + 8, 17, 17)];
    messageImageView.image = [UIImage imageNamed:@"fx_hd"];
    [self.contentView addSubview:messageImageView];
    
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(messageImageView.frame.origin.x + messageImageView.frame.size.width + 10, messageImageView.frame.origin.y, 64, 17)];
    self.messageLabel.text = @"互动(20)";
    self.messageLabel.textColor = baseblackColor;
    self.messageLabel.textAlignment = NSTextAlignmentLeft;
    self.messageLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.messageLabel];
    
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

- (void)clickHeaderBtn{
    if (self.block) {
        self.block();
    }
}

- (void)addBlock:(foundMainImageSelfViewCellBlock)block{
    self.block = block;
}

@end
