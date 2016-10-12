//
//  SR_ShareView.m
//  scanreader
//
//  Created by jbmac01 on 16/10/11.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_ShareView.h"
#import "globalHeader.h"

@implementation SR_ShareView

- (id)initShareViewWithBlock:(shareViewBlock)block{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        self.block = block;
        [self setupView];
    
    }
    return self;
}

- (void)setupView{
    
    NSArray * imageNames = @[@"weixing",@"pengyouquan",@"weibo",@"douban",@"QZONE"];
    UIView * iconBgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, (67 + 10)*(imageNames.count/4 + imageNames.count%4) + 10 + 10)];
    iconBgView.backgroundColor = [UIColor whiteColor];
    iconBgView.layer.cornerRadius = 5.0;
    [self addSubview:iconBgView];
    
    CGFloat boarder = (iconBgView.frame.size.width - 10 - 50*4)*1.0/3.0;
    for (int i = 0; i < imageNames.count; i ++) {
        UIButton * btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(5 + (i%4)*(50 + boarder), 10 + (i/4)*(10 + 67), 50, 67);
        [btn setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = i + 100;
        btn.titleLabel.font = [UIFont systemFontOfSize:10.0];
        [btn addTarget:self action:@selector(clickIconBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [iconBgView addSubview:btn];
    }
    
    UIButton * cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cancelBtn.frame = CGRectMake(10, iconBgView.frame.origin.y + iconBgView.frame.size.height + 10, iconBgView.frame.size.width, 50);
    cancelBtn.layer.cornerRadius = 5.0;
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancelBtn setTitleColor:kColor(0x6e, 0x96, 0xe8) forState:(UIControlStateNormal)];
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:cancelBtn];
}

- (void)clickIconBtn:(UIButton *)btn{
    if (self.block) {
        self.block(btn.tag);
    }
}

- (void)show{
    self.handerView = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _handerView.frame = [UIScreen mainScreen].bounds;
    _handerView.backgroundColor = [UIColor clearColor];
   // [_handerView addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchUpInside)];
    [_handerView addSubview:self];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_handerView];
    
    [UIView animateWithDuration:0.15 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        _handerView.backgroundColor = kColorAlpha(0, 0, 0, 0.20);
        self.frame = CGRectMake(0, kScreenHeight - sizeHeight(300), kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.15 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        _handerView.backgroundColor = kColorAlpha(0, 0, 0, 0);
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        [self.handerView removeFromSuperview];
    }];
}


@end
