//
//  SR_LoginViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_LoginViewController.h"
#import "globalHeader.h"
#import "SR_LoginBtn.h"
#import "SR_RegisterViewController.h"

@interface SR_LoginViewController()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField * phoneTextField;
@property(nonatomic,strong)UITextField * passwordTextField;
@property(nonatomic,strong)UIButton * loginBtn;
@property(nonatomic,assign)BOOL isVisable;
@end

@implementation SR_LoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title  = @"登录";
    [self setupLoginTextView];
    [self setupOtherLoginView];
}

- (void)setupLoginTextView{
    for (int i = 0; i < 2; i ++) {
        UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 64 + 55 + i*(15 + 40), 25, 25)];
        icon.backgroundColor = [UIColor redColor];
        [self.view addSubview:icon];
        
        UITextField * textfield = [[UITextField alloc] initWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width + 10, icon.frame.origin.y, kScreenWidth - icon.frame.size.width - 30 - 10, icon.frame.size.height)];
        textfield.textColor = [UIColor lightGrayColor];
        if (i == 0) {
            textfield.placeholder = @"输入手机号";
            textfield.keyboardType = UIKeyboardTypeASCIICapable;
            self.phoneTextField = textfield;
        }else{
            UIButton * visiableBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 25, 25, 25)];
            visiableBtn.backgroundColor = [UIColor redColor];
            [visiableBtn addTarget:self action:@selector(clickPasswordRightBtn) forControlEvents:(UIControlEventTouchUpInside)];
            textfield.rightView = visiableBtn;
            textfield.rightViewMode = UITextFieldViewModeAlways;
            textfield.placeholder = @"输入登录密码";
            textfield.secureTextEntry = YES;
            textfield.keyboardType = UIKeyboardTypeASCIICapable;
            self.passwordTextField = textfield;
        }
        textfield.delegate = self;
        textfield.font = [UIFont systemFontOfSize:14.0];
        [self.view addSubview:textfield];
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(15, textfield.frame.size.height + textfield.frame.origin.y + 15 , kScreenWidth - 30, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:lineView];
    }
    
    self.loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.loginBtn.frame = CGRectMake(15, 194 + 64, kScreenWidth - 30, 58);
    self.loginBtn.backgroundColor = baseColor;
    self.loginBtn.layer.cornerRadius = 29;
    [self.loginBtn setTitle:@"登录" forState:(UIControlStateNormal)];
    [self.loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.loginBtn];
    
}

- (void)setupOtherLoginView{
    NSArray * titles = @[@"微信登录",@"微博登录",@"QQ登录",@"豆瓣登录"];
    CGFloat boarder = (kScreenWidth - 30 - 58*4)*1.0/3.0;
    for (int i = 0; i < 4; i ++) {
        UIButton * btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(15 + i*(58 + boarder), kScreenHeight - 72 - 58, 58, 58);
        [btn setTitle:titles[i] forState:UIControlStateNormal];
       // [btn setImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 29;
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:10.0];
        btn.backgroundColor = baseColor;
        [btn addTarget:self action:@selector(clickOtherLoginBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:btn];
    }
}

- (void)clickPasswordRightBtn{
    SSLog(@"click righbtn");
    self.isVisable = !self.isVisable;
    self.passwordTextField.secureTextEntry = self.isVisable;
}

- (void)clickLoginBtn{
    SSLog(@"login");
    SR_RegisterViewController * registerVC = [[SR_RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)clickOtherLoginBtn:(UIButton *)btn{
    SSLog(@"tag:%d",btn.tag);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    return YES;
}

@end
