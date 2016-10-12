//
//  SR_ShareView.h
//  scanreader
//
//  Created by jbmac01 on 16/10/11.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^shareViewBlock)(NSInteger index);

@interface SR_ShareView : UIView
@property(nonatomic,strong)UIButton * handerView;
@property(nonatomic,strong)shareViewBlock block;
- (id)initShareViewWithBlock:(shareViewBlock)block;
- (void)show;
- (void)dismiss;

@end
