//
//  SR_ActionSheetTextView.m
//  scanreader
//
//  Created by admin on 16/7/24.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_ActionSheetTextView.h"
#import "globalHeader.h"
#import <SVProgressHUD.h>
#import <MBProgressHUD.h>
#import "requestAPI.h"
#import "httpTools.h"
#import "UserInfo.h"

@implementation SR_ActionSheetTextView

- (id)initActionSheetWith:(NSString *)title text:(NSString *)text{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        self.articleTitle = title;
        self.articleDetailText = text;
        self.backgroundColor = [UIColor whiteColor];
        [self setupView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)setupView{
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, sizeHeight(50))];
    leftView.backgroundColor = [UIColor whiteColor];
    self.titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth - 30, sizeHeight(50))];
    self.titleTextField.placeholder = @"请输入笔记标题";
    self.titleTextField.text = self.articleTitle;
    self.titleTextField.textColor = baseblackColor;
    self.titleTextField.font = [UIFont systemFontOfSize:16.0];
    self.titleTextField.layer.borderWidth = 1.0;
    self.titleTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.titleTextField.layer.cornerRadius = 2.0;
    self.titleTextField.delegate = self;
    self.titleTextField.leftViewMode = UITextFieldViewModeAlways;
    self.titleTextField.leftView = leftView;
    [self addSubview:self.titleTextField];
    
    self.textTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, self.titleTextField.frame.origin.y + self.titleTextField.frame.size.height + sizeHeight(10), kScreenWidth - 30, sizeHeight(260))];
    self.textTextView.text = self.articleDetailText;
    self.textTextView.textColor = baseblackColor;
    self.textTextView.layer.borderWidth = 1.0;
    self.textTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textTextView.layer.cornerRadius = 3.0;
    self.textTextView.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:self.textTextView];
    
    self.sendBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.sendBtn.frame = CGRectMake(kScreenWidth - 15 - 44, self.textTextView.frame.origin.y + self.textTextView.frame.size.height + sizeHeight(10), 44, sizeHeight(44) );
    [self.sendBtn setTitle:@"发送" forState:(UIControlStateNormal)];
    [self.sendBtn setTitleColor:baseColor forState:(UIControlStateNormal)];
    [self.sendBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
    [self.sendBtn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.sendBtn];
    
    UIButton * cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cancelBtn.frame = CGRectMake(15, self.sendBtn.frame.origin.y, 44, sizeHeight(44));
    [cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancelBtn setTitleColor:baseColor forState:(UIControlStateNormal)];
    [cancelBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchUpInside)];
    self.cancelBtn = cancelBtn;
    [self addSubview:cancelBtn];
}

- (void)show{
    self.handerView = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _handerView.frame = [UIScreen mainScreen].bounds;
    _handerView.backgroundColor = [UIColor clearColor];
    [_handerView addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchUpInside)];
    [_handerView addSubview:self];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_handerView];
    
    [UIView animateWithDuration:0.15 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        _handerView.backgroundColor = kColorAlpha(0, 0, 0, 0.20);
        self.frame = CGRectMake(0, kScreenHeight - sizeHeight(400), kScreenWidth, kScreenHeight);
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

- (void)clickBtn:(UIButton *)btn{
    if (!self.titleTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入标题"];
        return;
    }
    if (!self.textTextView.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入笔记内容"];
        return;
    }
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    NSDictionary * baseParam = @{@"user_id":userId,@"user_token":userToken,@"type":NOTE_TYPE_TEXT,
                             @"title":self.titleTextField.text,@"content":self.textTextView.text};
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc] initWithDictionary:baseParam];

    NSString * baseUrl = SAVE_NOTE;
    if ([self.requestType isEqualToString:NOTE_REQUSERT_TYPE_SAVE]) {
        baseUrl = SAVE_NOTE;
        if (self.book_id) {//创建有对象
            param[@"book_id"] = self.book_id;
        }
    }else if ([self.requestType isEqualToString:NOTE_REQUSERT_TYPE_UPDATE]){
        baseUrl = UPDATE_NOTE;
        if (self.noteId) {//更新笔记
            param[@"id"] = self.noteId;
        }
    }
    
    MBProgressHUD * hud = [[MBProgressHUD  alloc] initWithView:self.handerView];
    [hud showAnimated:YES];
    [btn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    btn.enabled = NO;
    [httpTools post:baseUrl andParameters:param success:^(NSDictionary *dic) {
        [btn setTitleColor:baseColor forState:(UIControlStateNormal)];
        btn.enabled = YES;
        [hud hideAnimated:YES];
        [SVProgressHUD showSuccessWithStatus:@"更新成功"];
        if ([self.delegate conformsToProtocol:@protocol(textViewSendBtnDelegate)] && [self.delegate respondsToSelector:@selector(clickTextViewSendBtn:text:)]) {
            [self.delegate clickTextViewSendBtn:self.titleTextField.text text:self.textTextView.text];
        }
        [self dismiss];
    } failure:^(NSError *error) {
        [btn setTitleColor:baseColor forState:(UIControlStateNormal)];
        btn.enabled = YES;
        [hud hideAnimated:YES];
        [SVProgressHUD showErrorWithStatus:@"更新失败"];
    }];
    
    
}

#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    CGRect keyBoardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (!keyBoardRect.size.height) {
        return;
    }
    CGFloat keyBoardRectHeight = keyBoardRect.size.height/2;
    if (!self.titleTextField.editing) {
        keyBoardRectHeight = keyBoardRect.size.height - 10;
    }
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.frame = CGRectMake(0, kScreenHeight - sizeHeight(400) - keyBoardRectHeight, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished){
        
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.frame = CGRectMake(0, kScreenHeight - sizeHeight(400), kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    return YES;
}

@end
