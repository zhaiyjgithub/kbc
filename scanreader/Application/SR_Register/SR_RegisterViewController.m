//
//  SR_RegisterViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_RegisterViewController.h"
#import "globalHeader.h"
@interface SR_RegisterViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField * phoneTextField;
@property(nonatomic,strong)UITextField * passwordTextField;
@property(nonatomic,strong)UIButton * registerBtn;
@property(nonatomic,assign)BOOL isVisable;
@property(nonatomic,nonnull)UITextField * checkCodeTextield;
@end

@implementation SR_RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册";
    [self setupRegisterView];
}

- (void)setupRegisterView{
    for (int i = 0; i < 3; i ++) {
        UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 64 + 55 + i*(15 + 40), 25, 25)];
        icon.backgroundColor = [UIColor redColor];
        [self.view addSubview:icon];
        
        UITextField * textfield = [[UITextField alloc] initWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width + 10, icon.frame.origin.y, kScreenWidth - icon.frame.size.width - 30 - 10, icon.frame.size.height)];
        textfield.textColor = [UIColor lightGrayColor];
        if (i == 0) {
            textfield.placeholder = @"输入手机号";
            textfield.keyboardType = UIKeyboardTypeASCIICapable;
            self.phoneTextField = textfield;
        }else if (i ==1){
            UIButton * visiableBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 25, 25, 25)];
            visiableBtn.backgroundColor = [UIColor redColor];
            [visiableBtn addTarget:self action:@selector(clickPasswordRightBtn) forControlEvents:(UIControlEventTouchUpInside)];
            textfield.rightView = visiableBtn;
            textfield.rightViewMode = UITextFieldViewModeAlways;
            textfield.placeholder = @"输入登录密码";
            textfield.secureTextEntry = YES;
            textfield.keyboardType = UIKeyboardTypeASCIICapable;
            self.passwordTextField = textfield;
        }else{
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
        }
        textfield.delegate = self;
        textfield.font = [UIFont systemFontOfSize:14.0];
        [self.view addSubview:textfield];
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(15, textfield.frame.size.height + textfield.frame.origin.y + 15 , kScreenWidth - 30, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:lineView];
    }
    self.registerBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.registerBtn.frame = CGRectMake(15, 244 + 64, kScreenWidth - 30, 58);
    self.registerBtn.backgroundColor = baseColor;
    self.registerBtn.layer.cornerRadius = 29;
    [self.registerBtn setTitle:@"注册" forState:(UIControlStateNormal)];
    [self.registerBtn addTarget:self action:@selector(clickregisterBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.registerBtn];
}

- (void)clickCheckCodeBtn{
    SSLog(@"code..");
}
- (void)clickPasswordRightBtn{
    SSLog(@"click righbtn");
    self.isVisable = !self.isVisable;
    self.passwordTextField.secureTextEntry = self.isVisable;
}

- (void)clickregisterBtn{
    SSLog(@"login");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    return YES;
}


@end
