//
//  SR_RegisterViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_RegisterViewController.h"
#import "globalHeader.h"
#import <SVProgressHUD.h>
#import "MBProgressHUD.h"
#import "httpTools.h"
#import "UserInfo.h"
#import "SR_TabbarViewController.h"

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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemCancel) target:self action:@selector(clickLeftBarItem)];
}

- (void)clickLeftBarItem{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupRegisterView{
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
            UIButton * visiableBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
            [visiableBtn setImage:[UIImage imageNamed:@"login_eye_nor"] forState:(UIControlStateNormal)];
            [visiableBtn setImage:[UIImage imageNamed:@"login_eye_hl"] forState:(UIControlStateSelected)];
            [visiableBtn addTarget:self action:@selector(clickPasswordRightBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            textfield.rightView = visiableBtn;
            textfield.rightViewMode = UITextFieldViewModeAlways;
            textfield.placeholder = @"输入登录密码";
            textfield.secureTextEntry = !self.isVisable;
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
    [self.registerBtn setTitle:@"注册" forState:(UIControlStateNormal)];
    [self.registerBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
    [self.registerBtn addTarget:self action:@selector(clickregisterBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.registerBtn];
}

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
    if (self.phoneTextField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"手机号码错误"];
        return;
    }
    
    if (!self.passwordTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
    
    if (!self.checkCodeTextield.text.length) {
        [SVProgressHUD showErrorWithStatus:@"验证码不能为空"];
        return;
    }
    //当前验证码暂时为空
    NSString * code = @"1234";
    NSDictionary * param = @{@"username":self.phoneTextField.text,@"password":self.passwordTextField.text,@"mobile":self.phoneTextField.text,@"code":code};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [httpTools post:REGISTER andParameters:param success:^(NSDictionary *dic) {
        [hud hideAnimated:YES];
        SSLog(@"REGISTER: %@",dic);
        //注册成功后，覆盖原来的归档，并创建新的数据库，创建user表
        NSDictionary * userDic = dic[@"data"][@"user"];
        [UserInfo saveUserAvatarWith:userDic[@"avatar"]];
        [UserInfo saveUserIDWith:userDic[@"id"]];
        [UserInfo saveUserTokenWith:userDic[@"user_token"]];
        [UserInfo saveUserNameWith:userDic[@"username"]];
        [UserInfo saveUserPhoneNumberWith:self.phoneTextField.text];
        [UserInfo saveUserPasswordWith:self.passwordTextField.text];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[SR_TabbarViewController alloc] init];
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
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
