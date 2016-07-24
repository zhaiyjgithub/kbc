//
//  SR_ActionSheetTextView.h
//  scanreader
//
//  Created by admin on 16/7/24.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol textViewSendBtnDelegate <NSObject>

@optional
- (void)clickSendBtn:(NSString *)title text:(NSString *)text;
@end

@interface SR_ActionSheetTextView : UIView<UITextFieldDelegate>
@property(nonatomic,strong)UIButton * handerView;
@property(nonatomic,weak)id<textViewSendBtnDelegate>delegate;
@property(nonatomic,copy)NSString * articleTitle;
@property(nonatomic,copy)NSString * articleDetailText;
@property(nonatomic,strong)UITextField * titleTextField;
@property(nonatomic,strong)UITextView * textTextView;
@property(nonatomic,strong)UIButton * sendBtn;
- (id)initActionSheetWith:(NSString *)title text:(NSString *)text;
- (void)show;
- (void)dismiss;
@end
