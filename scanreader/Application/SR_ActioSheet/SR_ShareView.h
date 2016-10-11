//
//  SR_ShareView.h
//  scanreader
//
//  Created by jbmac01 on 16/10/11.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SR_ShareViewDelegate <NSObject>

@optional
- (void)clickShareViewBtnIndex:(NSInteger)index;

@end

@interface SR_ShareView : UIView
@property(nonatomic,strong)UIButton * handerView;
@property(nonatomic,weak)id<SR_ShareViewDelegate>delegate;
- (id)initShareView;
- (void)show;
- (void)dismiss;
@end
