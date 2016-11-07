//
//  PreScanView.m
//  scanreader
//
//  Created by jbmac01 on 16/10/24.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_PreScanView.h"
#import "globalHeader.h"
#import <YYKit/YYKit.h>

@implementation SR_PreScanView

- (id)initPreScanViewWithImagePath:(NSString *)imagePath{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.imagePath = imagePath;
        [self setupView];
    }
    return self;
}

- (void)setupView{
    YYAnimatedImageView * preScanImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    preScanImageView.contentMode = UIViewContentModeScaleAspectFit;
    [preScanImageView setImageWithURL:[NSURL URLWithString:self.imagePath] options:(YYWebImageOptionProgressiveBlur)];
    self.preScanImageView = preScanImageView;
    self.preScanImageView.userInteractionEnabled = YES;
    [self addSubview:preScanImageView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [preScanImageView addGestureRecognizer:tap];
}

- (void)show{
    self.handerView = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _handerView.frame = [UIScreen mainScreen].bounds;
    _handerView.backgroundColor = [UIColor clearColor];
     [_handerView addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchUpInside)];
    [_handerView addSubview:self];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_handerView];
    self.preScanImageView.alpha = 0.0;
    [UIView animateWithDuration:0.15 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        self.preScanImageView.alpha = 1.0;
        _handerView.backgroundColor = [UIColor blackColor];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss{
    _handerView.backgroundColor = [UIColor blackColor];
    [UIView animateWithDuration:0.15 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        self.preScanImageView.alpha = 0.0;
        _handerView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self.handerView removeFromSuperview];
    }];
}

@end
