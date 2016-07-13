//
//  SR_AddBtnView.m
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_AddBtnView.h"
#import "globalHeader.h"
#import "SR_OAthouButton.h"

@implementation SR_AddBtnView
- (id)initAlertView{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 170, 170);
        self.center = CGPointMake(kScreenWidth, kScreenHeight/2);
        self.backgroundColor = kColorAlpha(78, 225, 221, 0.5);//kColor(78,225,221)
        self.layer.cornerRadius = 85;
        [self setupView];
    }
    return self;
}

- (void)setupView{
    NSArray * titles = @[@"文字",@"语音",@"拍照"];
    CGFloat boarder = (170 - 90 - 18 * 3)*1.0/2.0;
    for (int i = 0; i < 3; i ++) {
        SR_OAthouButton * btn = [[SR_OAthouButton alloc] initWithType:(BaseButtonTypeLeft) sizeType:(BaseButtonSizeTypeSmall)];
        btn.frame = CGRectMake(20,45 + i * (18 + boarder), 60,18);
        [btn setTitle:titles[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@"oathu1"] forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.tag = i;
        [self addSubview:btn];
    }
}

- (void)show{
    self.handerView = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _handerView.frame = [UIScreen mainScreen].bounds;
    _handerView.backgroundColor = [UIColor clearColor];
    [_handerView addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchUpInside)];
    [_handerView addSubview:self];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_handerView];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        _handerView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        self.alpha = 0;
        _handerView.backgroundColor = kColorAlpha(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        [self.handerView removeFromSuperview];
    }];
}

- (void)clickBtn:(UIButton *)btn{
    if ([self.delegate conformsToProtocol:@protocol(addBtnDelegate)] && [self.delegate respondsToSelector:@selector(clickAddBtnView:)]) {
        [self.delegate clickAddBtnView:btn.tag];
    }
    
    [self dismiss];
}

@end
