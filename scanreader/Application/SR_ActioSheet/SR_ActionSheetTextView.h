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
- (void)clickTextViewSendBtn:(NSString *)title text:(NSString *)text;
@end

@interface SR_ActionSheetTextView : UIView<UITextFieldDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UIButton * handerView;
@property(nonatomic,weak)id<textViewSendBtnDelegate>delegate;
@property(nonatomic,copy)NSString * articleTitle;
@property(nonatomic,copy)NSString * articleDetailText;
@property(nonatomic,strong)UITextField * titleTextField;
@property(nonatomic,strong)UITextView * textTextView;
@property(nonatomic,strong)UIButton * sendBtn;
@property(nonatomic,strong)UIButton * cancelBtn;
@property(nonatomic,copy)NSString * noteId;
@property(nonatomic,copy)NSString * book_id;
@property(nonatomic,copy)NSString * page_id;
@property(nonatomic,copy)NSString * requestType;
- (id)initActionSheetWith:(NSString *)title text:(NSString *)text;
- (void)show;
- (void)dismiss;
@end
