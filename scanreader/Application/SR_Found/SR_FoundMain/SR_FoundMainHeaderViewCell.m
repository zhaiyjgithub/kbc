//
//  SR_FoundMainHeaderViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/9/1.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_FoundMainHeaderViewCell.h"
#import "globalHeader.h"

@implementation SR_FoundMainHeaderViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell{
    NSArray * titles = @[@"动态",@"读书会"];
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 42)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.headerBgView = headerView;
    [self.contentView addSubview:headerView];
    for (int i = 0; i < 2; i ++) {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i*(kScreenWidth/2), 1, kScreenWidth/2, 42)];
        [btn setTitle:titles[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:baseColor forState:(UIControlStateNormal)];
        [btn setTitle:titles[i] forState:(UIControlStateSelected)];
        [btn setTitleColor:kColor(0x88, 0x88, 0x88) forState:(UIControlStateSelected)];
        btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        if (i == 0) {
            [btn setSelected:self.isSelectBookClub];
            
        }else{
            [btn setSelected:!self.isSelectBookClub];
        }
        btn.tag = i;
        [btn addTarget:self action:@selector(clickHeaderBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [headerView addSubview:btn];
    }
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2, 1, 0.5, 40)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:lineView];
}

- (void)setIsSelectBookClub:(BOOL)isSelectBookClub{
    _isSelectBookClub = isSelectBookClub;
    NSArray * sonBtn = [self.headerBgView subviews];
    for (int i = 0 ; i < sonBtn.count; i ++) {
        if ([sonBtn[i] isKindOfClass:[UIButton class]]) {
            UIButton * btn = (UIButton *)sonBtn[i];
            
            if (i == 0) {
                [btn setSelected:self.isSelectBookClub];
            }else{
                [btn setSelected:!self.isSelectBookClub];
            }

        }
       
    }
}

- (void)clickHeaderBtn:(UIButton *)btn{
    if (self.block) {
        self.block(btn.tag);
    }
}

- (void)addBlock:(foundMainHeaderViewCellBtnBlock)block{
    self.block = block;
}

@end
