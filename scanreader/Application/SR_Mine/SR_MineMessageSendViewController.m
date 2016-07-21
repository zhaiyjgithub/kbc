//
//  SR_MineMessageSendViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/19.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_MineMessageSendViewController.h"
#import "globalHeader.h"

@interface SR_MineMessageSendViewController ()
@property(nonatomic,strong)UIView * toolBar;
@property(nonatomic,strong)UITextField * toolBarTextField;
@property(nonatomic,strong)UIButton * toolBarSendBtn;
@end

@implementation SR_MineMessageSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户名称";
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self setupToolBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupToolBar{
    self.toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50)];
    self.toolBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.toolBar];
    
    self.toolBarTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 3, kScreenWidth - 10 - 10 - 10 -44, 44)];
    self.toolBarTextField.backgroundColor = [UIColor whiteColor];
    [self.toolBar addSubview:self.toolBarTextField];
    
    self.toolBarSendBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.toolBarSendBtn.frame = CGRectMake(kScreenWidth - 10 - 44, 3, 44, 44);
    [self.toolBarSendBtn setTitle:@"发送" forState:(UIControlStateNormal)];
    [self.toolBarSendBtn setTitleColor:baseColor forState:(UIControlStateNormal)];
    [self.toolBarSendBtn addTarget:self action:@selector(clickSendBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.toolBar addSubview:self.toolBarSendBtn];
}

- (void)clickSendBtn{
    SSLog(@"send btn");
}

#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    CGRect keyBoardRect = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    if (!keyBoardRect.size.height) {
        return;
    }
    [UIView animateWithDuration:animationDuration animations:^{
    
    
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
    }];
    
}


@end
