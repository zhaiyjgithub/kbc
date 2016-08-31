//
//  SR_InterPageDetailVideoViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/8/31.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_InterPageDetailVideoViewCell.h"
#import "globalHeader.h"

@implementation SR_InterPageDetailVideoViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, (kScreenWidth - 30), 15)];
    self.titleLabel.text = @"笔记标题";
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
    
    NSString *urlStr = @"http://7xawdc.com2.z0.glb.qiniucdn.com/o_19p6vdmi9148s16fs1ptehbm1vd59.mp4";
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url1 = [NSURL URLWithString:urlStr];
    
    self.videoBgView = [[UIView alloc] init];
    self.videoBgView.frame =  CGRectMake(20, 60, kScreenWidth - 40, (kScreenWidth - 40)*0.75);
    [self.contentView addSubview:self.videoBgView];
    
    MPMoviePlayerController * mpc = [[MPMoviePlayerController alloc] init];
    mpc.contentURL = url1;//[NSURL URLWithString:url];
    mpc.view.frame = self.videoBgView.bounds;
    [self.videoBgView addSubview:mpc.view];
    self.mpc = mpc;
    
    self.playBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.playBtn.frame = CGRectMake(0, 0, 44, 44);
    self.playBtn.center = CGPointMake(kScreenWidth/2, 60 + (kScreenWidth - 40)*0.75*0.5);
    [self.playBtn setImage:[UIImage imageNamed:@"hdy_shiping_bofang"] forState:(UIControlStateNormal)];
    [self.playBtn addTarget:self action:@selector(clickPlayBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:self.playBtn];
}

- (void)clickPlayBtn:(UIButton *)btn{
    btn.hidden = YES;
    [self.mpc play];
}

- (void)setTextFrameModel:(SR_InterPageTextFrameModel *)textFrameModel{
    _textFrameModel = textFrameModel;
    self.titleLabel.text = textFrameModel.MoudleListItemModel.title;
    self.playBtn.hidden = NO;
    NSString *urlStr = @"http://7xawdc.com2.z0.glb.qiniucdn.com/o_19p6vdmi9148s16fs1ptehbm1vd59.mp4";
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url1 = [NSURL URLWithString:urlStr];
    
    for (UIView * sonView in self.videoBgView.subviews) {
        [sonView removeFromSuperview];
    }
    MPMoviePlayerController * mpc = [[MPMoviePlayerController alloc] init];
    mpc.contentURL = url1;//[NSURL URLWithString:url];
    mpc.view.frame = self.videoBgView.bounds;
    [self.videoBgView addSubview:mpc.view];
    self.mpc = mpc;
}

@end
