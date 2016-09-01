//
//  SR_MineViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_MineViewCell.h"
#import "globalHeader.h"
#import "UserInfo.h"

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
    self.levelabel.text = @"等级: 0级";
    self.levelabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.levelabel];
    
    self.OAthuabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.levelabel.frame.origin.y + self.levelabel.frame.size.height + 12, 84, 14)];
    self.OAthuabel.font = [UIFont boldSystemFontOfSize:14.0];
    self.OAthuabel.textColor = [UIColor blackColor];
    self.OAthuabel.text = @"对所有笔记";
    self.OAthuabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.OAthuabel];
    
    NSString * isPublic = [UserInfo getUserPublic];
    NSInteger publicBtnTag = [isPublic isEqualToString:@"1"] ? 0 : 1;
    NSArray * titles = @[@"公开",@"私密"];
    for (int i = 0; i < 2; i ++) {
         SR_OAthouButton * btn = [[SR_OAthouButton alloc] initWithType:(BaseButtonTypeLeft) sizeType:(BaseButtonSizeTypeSmall)];
        btn.frame = CGRectMake(self.OAthuabel.frame.size.width + self.OAthuabel.frame.origin.x + 20 + i*(60 + 30), self.OAthuabel.frame.origin.y - 1, 60, 16);
        [btn setTitle:titles[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateSelected)];
        [btn setImage:[UIImage imageNamed:@"wo_wxz"] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@"wo_xz"] forState:(UIControlStateSelected)];
        if (i == publicBtnTag) {
            [btn setSelected:YES];
        }
        btn.tag = i+100;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:btn];
    }
    
    UIButton * messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, self.OAthuabel.frame.origin.y + self.OAthuabel.frame.size.height + 20, 18, 12)];
    [messageBtn setImage:[UIImage imageNamed:@"wo_xx"] forState:(UIControlStateNormal)];
    messageBtn.tag = 102;
    [messageBtn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:messageBtn];
    
    UIButton * messageLabelBtn = [[UIButton alloc] initWithFrame:CGRectMake(messageBtn.frame.origin.x + messageBtn.frame.size.width, messageBtn.frame.origin.y - 1.5, 60, 15)];
    [messageLabelBtn setTitle:@"我的私信" forState:(UIControlStateNormal)];
    [messageLabelBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    messageLabelBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    messageLabelBtn.backgroundColor = [UIColor whiteColor];
    messageLabelBtn.tag = 103;
    [messageLabelBtn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:messageLabelBtn];
    
    self.dotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
    self.dotView.center = CGPointMake(messageBtn.frame.origin.x + messageBtn.frame.size.width, messageBtn.frame.origin.y);
    self.dotView.backgroundColor = [UIColor redColor];
    self.dotView.layer.cornerRadius = 3.0;
    [self.contentView addSubview:self.dotView];
}

- (void)clickBtn:(UIButton *)btn{
    if (btn.tag != 103) {
        [btn setSelected:YES];
        NSInteger tag = 100;
        if (btn.tag == 100) {
            tag = 101;
        }
        UIButton * otherBtn = (UIButton *)[self.contentView viewWithTag:tag];
        [otherBtn setSelected:NO];
        self.isSelectedOpen = !self.isSelectedOpen;
    }
    if (self.block) {
        self.block(btn);
    }
}

- (void)addBlock:(mineCellBlock)block{
    self.block = block;
}

@end
