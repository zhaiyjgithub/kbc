//
//  SR_OthersMineViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_OthersMineViewCell.h"
#import "globalHeader.h"
#import "SR_OAthouButton.h"

@implementation SR_OthersMineViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell{
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, kScreenWidth - 30, 14)];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14.0];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.text = @"用户名称: 周明";
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.nameLabel];
    
    self.levelabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 12, kScreenWidth - 30, 14)];
    self.levelabel.font = [UIFont boldSystemFontOfSize:14.0];
    self.levelabel.textColor = [UIColor blackColor];
    self.levelabel.text = @"等级: 1级";
    self.levelabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.levelabel];
    
    UIButton * messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, self.levelabel.frame.origin.y + self.levelabel.frame.size.height + 20, 15, 12)];
    messageBtn.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:messageBtn];
    
    UIButton * messageLabelBtn = [[UIButton alloc] initWithFrame:CGRectMake(messageBtn.frame.origin.x + messageBtn.frame.size.width + 5, messageBtn.frame.origin.y, 60, 15)];
    [messageLabelBtn setTitle:@"我的私信" forState:(UIControlStateNormal)];
    [messageLabelBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    messageLabelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    messageLabelBtn.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:messageLabelBtn];
    
    UITextView * messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, messageLabelBtn.frame.origin.y + messageLabelBtn.frame.size.height + 12, kScreenWidth - 30, 168)];
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

- (void)addBlock:(othersMineCellBlock)block{
    self.block = block;
}
    

@end
