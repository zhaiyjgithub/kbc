//
//  SR_MineViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_MineViewCell.h"
#import "globalHeader.h"

@implementation SR_MineViewCell

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
    
    self.OAthuabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.levelabel.frame.origin.y + self.levelabel.frame.size.height + 12, 84, 14)];
    self.OAthuabel.font = [UIFont boldSystemFontOfSize:14.0];
    self.OAthuabel.textColor = [UIColor blackColor];
    self.OAthuabel.text = @"对所有笔记";
    self.OAthuabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.OAthuabel];
    
   
    NSArray * titles = @[@"公开",@"私密"];
    for (int i = 0; i < 2; i ++) {
         SR_OAthouButton * btn = [[SR_OAthouButton alloc] initWithType:(BaseButtonTypeLeft) sizeType:(BaseButtonSizeTypeSmall)];
        btn.frame = CGRectMake(self.OAthuabel.frame.size.width + self.OAthuabel.frame.origin.x + 20 + i*(60 + 30), self.OAthuabel.frame.origin.y - 1, 60, 16);
        [btn setTitle:titles[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateSelected)];
        [btn setImage:[UIImage imageNamed:@"oathu1"] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@"oathu2"] forState:(UIControlStateSelected)];
        btn.tag = i+100;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:btn];
    }
    
    UIButton * messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, self.OAthuabel.frame.origin.y + self.OAthuabel.frame.size.height + 20, 15, 12)];
    messageBtn.backgroundColor = [UIColor redColor];
    messageBtn.tag = 102;
    [messageBtn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:messageBtn];
    
    UIButton * messageLabelBtn = [[UIButton alloc] initWithFrame:CGRectMake(messageBtn.frame.origin.x + messageBtn.frame.size.width + 5, messageBtn.frame.origin.y, 60, 15)];
    [messageLabelBtn setTitle:@"我的私信" forState:(UIControlStateNormal)];
    [messageLabelBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    messageLabelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    messageLabelBtn.backgroundColor = [UIColor whiteColor];
    messageLabelBtn.tag = 3;
    [messageLabelBtn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:messageLabelBtn];
}

- (void)clickBtn:(UIButton *)btn{
    if (self.block) {
        self.block(btn);
    }
}

- (void)addBlock:(mineCellBlock)block{
    self.block = block;
}

@end
