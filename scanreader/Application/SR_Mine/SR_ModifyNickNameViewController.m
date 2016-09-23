//
//  SR_ModifyNickNameViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/9/3.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_ModifyNickNameViewController.h"
#import "globalHeader.h"
#import "UserInfo.h"
#import "requestAPI.h"
#import "httpTools.h"
#import <MBProgressHUD.h>
#import <SVProgressHUD.h>

@interface SR_ModifyNickNameViewController()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField * nickNameTextField;
@end

@implementation SR_ModifyNickNameViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"更改名称";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(clickRightBarItem)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSString * name = [UserInfo getUserName];
    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.nickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 64 + 8, kScreenWidth, 50)];
    self.nickNameTextField.text = name;
    self.nickNameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.nickNameTextField.leftView = leftView;
    self.nickNameTextField.placeholder = @"请输入你的昵称";
    self.nickNameTextField.delegate = self;
    self.nickNameTextField.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.nickNameTextField.layer.borderWidth = 0.5;
    self.nickNameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.nickNameTextField becomeFirstResponder];
    [self.view addSubview:self.nickNameTextField];
}

- (void)clickRightBarItem{
    if (!self.nickNameTextField.text.length) {
       UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"更新失败" message:@"输入的用户名称不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSDictionary * info = @{@"username":self.nickNameTextField.text};
    [self updateUserInfo:info];
}

- (void)updateUserInfo:(NSDictionary *)info{
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    NSMutableDictionary * param = [[NSMutableDictionary alloc] initWithDictionary: @{@"user_id":userId,@"user_token":userToken}];
    [param addEntriesFromDictionary:info];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [httpTools post:UPDATE_USER_INFO andParameters:param success:^(NSDictionary *dic) {
        SSLog(@"更新完毕");
        [UserInfo saveUserNameWith:info[@"username"]];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([self.delegate conformsToProtocol:@protocol(modifyNickNameViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(updateNickName)]) {
            [self.delegate updateNickName];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}



@end
