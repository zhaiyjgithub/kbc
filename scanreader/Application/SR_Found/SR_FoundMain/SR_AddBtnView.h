//
//  SR_AddBtnView.h
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol addBtnDelegate <NSObject>

@optional
- (void)clickAddBtnView:(NSInteger)tag;

@end

@interface SR_AddBtnView : UIView
@property(nonatomic,strong)UIButton * handerView;
@property(nonatomic,weak)id<addBtnDelegate>delegate;
@property(nonatomic,copy)NSString * btnType;
- (id)initAlertViewWithType:(NSString *)type;
- (void)show;
- (void)dismiss;
@end
