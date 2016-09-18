//
//  SR_ForgotPasswordViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/21.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_ForgotPasswordViewController.h"
#import "globalHeader.h"
#import <SVProgressHUD.h>
#import <MBProgressHUD.h>
#import "httpTools.h"
#import "requestAPI.h"
#import "globalHeader.h"


@interface SR_ForgotPasswordViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField * phoneTextField;
@property(nonatomic,strong)UITextField * passwordTextField;
@property(nonatomic,strong)UIButton * registerBtn;
@property(nonatomic,assign)BOOL isVisable;
@property(nonatomic,nonnull)UITextField * checkCodeTextield;

@end

@implementation SR_ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"忘记密码";
    [self setupFindPWDView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemCancel) target:self action:@selector(clickLeftBarItem)];
}

- (void)clickLeftBarItem{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupFindPWDView{
    NSArray * iconImages = @[@"login_phone",@"login_yzm",@"login_yzm"];
    for (int i = 0; i < 3; i ++) {
        UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 64 + 55 + i*(15 + 40), 23, 23)];
        [icon setImage:[UIImage imageNamed:iconImages[i]]];
        [self.view addSubview:icon];
        
        UITextField * textfield = [[UITextField alloc] initWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width + 10, icon.frame.origin.y, kScreenWidth - icon.frame.size.width - 30 - 10, icon.frame.size.height)];
        textfield.textColor = [UIColor lightGrayColor];
        if (i == 0) {
            textfield.placeholder = @"输入手机号";
            textfield.keyboardType = UIKeyboardTypeASCIICapable;
            self.phoneTextField = textfield;
        }else if (i ==1){
            UIButton * checkCodeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            checkCodeBtn.frame = CGRectMake(0, 0, 125, 25);
            checkCodeBtn.backgroundColor = [UIColor whiteColor];
            checkCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [checkCodeBtn setTitle:@"验证码" forState:(UIControlStateNormal)];
            [checkCodeBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
            [checkCodeBtn addTarget:self action:@selector(clickCheckCodeBtn) forControlEvents:(UIControlEventTouchUpInside)];
            
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 2, 1, 21)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [checkCodeBtn addSubview:lineView];
            
            textfield.rightView = checkCodeBtn;
            textfield.rightViewMode = UITextFieldViewModeAlways;
            textfield.placeholder = @"输入验证码";
            textfield.keyboardType = UIKeyboardTypeASCIICapable;
            self.checkCodeTextield = textfield;
        }else{
            UIButton * visiableBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
            [visiableBtn setImage:[UIImage imageNamed:@"login_eye_nor"] forState:(UIControlStateNormal)];
            [visiableBtn setImage:[UIImage imageNamed:@"login_eye_hl"] forState:(UIControlStateSelected)];
            [visiableBtn addTarget:self action:@selector(clickPasswordRightBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            textfield.rightView = visiableBtn;
            textfield.rightViewMode = UITextFieldViewModeAlways;
            textfield.placeholder = @"输入新密码";
            textfield.secureTextEntry = !self.isVisable;
            textfield.keyboardType = UIKeyboardTypeASCIICapable;
            self.passwordTextField = textfield;
        }
        textfield.delegate = self;
        textfield.textColor = [UIColor blackColor];
        textfield.font = [UIFont systemFontOfSize:14.0];
        [self.view addSubview:textfield];
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(15, textfield.frame.size.height + textfield.frame.origin.y + 15 , kScreenWidth - 30, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:lineView];
    }
    self.registerBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.registerBtn.frame = CGRectMake(15, 224 + 64, kScreenWidth - 30, 58);
    self.registerBtn.backgroundColor = baseColor;
    self.registerBtn.layer.cornerRadius = 29;
    [self.registerBtn setTitle:@"完成" forState:(UIControlStateNormal)];
    [self.registerBtn addTarget:self action:@selector(clickregisterBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.registerBtn];
}

///当前默认是1234
- (void)clickCheckCodeBtn{
    SSLog(@"code..");
}
- (void)clickPasswordRightBtn:(UIButton *)btn{
    SSLog(@"click righbtn");
    self.isVisable = !self.isVisable;
    [btn setSelected:self.isVisable];
    self.passwordTextField.secureTextEntry = !self.isVisable;
}

- (void)clickregisterBtn{
    SSLog(@"find pwd");
    self.checkCodeTextield.text = @"1234";
    if (!self.phoneTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    
    if (!self.checkCodeTextield.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    if (!self.passwordTextField.text.length){
        [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
        return;
    }
    NSDictionary * param = @{@"password":self.passwordTextField.text,@"mobile":self.phoneTextField.text,
                             @"code":self.checkCodeTextield.text};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [httpTools post:FIND_PASSOWRD andParameters:param success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVProgressHUD showErrorWithStatus:@"找回密码成功！"];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    return YES;
}



@end
