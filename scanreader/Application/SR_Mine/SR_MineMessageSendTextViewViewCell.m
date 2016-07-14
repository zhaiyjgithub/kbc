//
//  SR_MineMessageSendTextViewViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/7/14.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_MineMessageSendTextViewViewCell.h"
#import "globalHeader.h"
#import "SR_OAthouButton.h"

@implementation SR_MineMessageSendTextViewViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 60, 16)];
    titleLabel.text = @"回复TA";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    [self.contentView addSubview:titleLabel];
    
    UITextView * messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, titleLabel.frame.origin.y + titleLabel.frame.size.height + 12, kScreenWidth - 30, 168)];
    messageTextView.layer.borderWidth  = 0.5;
    messageTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    messageTextView.font = [UIFont systemFontOfSize:14.0];
    self.messageTextView = messageTextView;
    [self.contentView addSubview:messageTextView];
    
    SR_OAthouButton * sentBtn = [[SR_OAthouButton alloc] initWithType:(BaseButtonTypeLeft) sizeType:(BaseButtonSizeTypeSmall)];
    sentBtn.frame = CGRectMake(kScreenWidth - 15 - 55, messageTextView.frame.origin.y + messageTextView.frame.size.height + 10, 55, 16);
    [sentBtn setTitle:@"发送" forState:(UIControlStateNormal)];
    [sentBtn setTitleColor:baseColor forState:(UIControlStateNormal)];
    sentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [sentBtn setImage:[UIImage imageNamed:@"oathu1"] forState:(UIControlStateNormal)];
    [sentBtn addTarget:self action:@selector(clickSendBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:sentBtn];
}

- (void)clickSendBtn:(UIButton *)btn{
    if (self.block) {
        self.block(self.messageTextView);
    }
}

- (void)addBlock:(mineMessageSendTextViewViewCellBlock)block{
    self.block = block;
}

@end
