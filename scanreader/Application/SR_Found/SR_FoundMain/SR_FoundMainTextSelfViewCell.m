//
//  SR_FoundMainTextSelfViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/7/21.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_FoundMainTextSelfViewCell.h"
#import "globalHeader.h"

@implementation SR_FoundMainTextSelfViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 125, 17)];
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
    
    self.bodyTextLabel = [[UILabel alloc] init];
    self.bodyTextLabel.frame = CGRectMake(18, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 8, kScreenWidth - 30 - 10 - 48, 39);
    self.bodyTextLabel.backgroundColor = [UIColor whiteColor];
    self.bodyTextLabel.text = @"因为 iOS 的音频资源被设计为单例资源，所以如果在 player 中做的任何修改，对外都可能造成影响，并且带来不能预估的各种问题。";
    self.bodyTextLabel.textColor = [UIColor lightGrayColor];
    self.bodyTextLabel.font = [UIFont systemFontOfSize:14.0];
    self.bodyTextLabel.numberOfLines = 0;
    [self.contentView addSubview:self.bodyTextLabel];
    
    UIImageView * messageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.bodyTextLabel.frame.origin.y + self.bodyTextLabel.frame.size.height + 8, 17, 17)];
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

- (void)addBlock:(foundMainTextSelfViewCellBlock)block{
    self.block = block;
}
@end
