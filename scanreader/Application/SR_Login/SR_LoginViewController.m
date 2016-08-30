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
#import "SR_TabbarViewController.h"
#import "SR_ForgotPasswordViewController.h"
#import "httpTools.h"
#import "SVProgressHUD.h"
#import "UserInfo.h"

@interface SR_LoginViewController()<UITextFieldDelegate>
@property(nonatomic,strong)UIView * loginBgView;
@property(nonatomic,strong)UITextField * phoneTextField;
@property(nonatomic,strong)UITextField * passwordTextField;
@property(nonatomic,strong)UIButton * loginBtn;
@property(nonatomic,assign)BOOL isVisable;
@property(nonatomic,assign)float bottomHeight;
@end

@implementation SR_LoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title  = @"登录";
    self.loginBgView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.loginBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.loginBgView];
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapGestureView)];
    self.loginBgView.userInteractionEnabled = YES;
    [self.loginBgView addGestureRecognizer:gesture];
    
    [self setupOtherLoginView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)TapGestureView{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)setupOtherLoginView{
    UILabel * appNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 34)];
    appNameLabel.center = CGPointMake(kScreenWidth/2, 64 + 34/2);
    appNameLabel.text = @"阅友";
    appNameLabel.textColor = [UIColor blackColor];
    appNameLabel.textAlignment = NSTextAlignmentCenter;
    appNameLabel.font = [UIFont systemFontOfSize:34.0];
    [self.loginBgView addSubview:appNameLabel];
    
    UILabel * recommandTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, appNameLabel.frame.size.height + appNameLabel.frame.origin.y + sizeHeight(34), 280, 14)];
    recommandTitleLabel.text = @"推荐使用第三方登录";
    recommandTitleLabel.textColor = [UIColor blackColor];
    recommandTitleLabel.textAlignment = NSTextAlignmentLeft;
    recommandTitleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.loginBgView addSubview:recommandTitleLabel];
    
    NSArray * imageNames = @[@"wx",@"wb",@"qq",@"db"];
    CGFloat boarder = (kScreenWidth - 30 - 74*4)*1.0/3.0;
    for (int i = 0; i < 4; i ++) {
        UIButton * btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(15 + i*(74 + boarder), recommandTitleLabel.frame.origin.y + recommandTitleLabel.frame.size.height + sizeHeight(28), 74, 74);
        [btn setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 37;
        btn.tag = i;
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:10.0];
        [btn addTarget:self action:@selector(clickOtherLoginBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.loginBgView addSubview:btn];
    }
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, recommandTitleLabel.frame.origin.y + recommandTitleLabel.frame.size.height + sizeHeight(136), kScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.loginBgView addSubview:lineView];
    
    NSArray * textFieldImages = @[@"login_phone",@"login_yzm"];
    for (int i = 0; i < 2; i ++) {
        UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, recommandTitleLabel.frame.origin.y + recommandTitleLabel.frame.size.height + sizeHeight(222) + i*(15 + 40), 23, 23)];
        icon.image = [UIImage imageNamed:textFieldImages[i]];
        [self.loginBgView addSubview:icon];
        
        UITextField * textfield = [[UITextField alloc] initWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width + 10, icon.frame.origin.y, kScreenWidth - icon.frame.size.width - 30 - 10, icon.frame.size.height)];
        textfield.textColor = [UIColor lightGrayColor];
        if (i == 0) {
            textfield.placeholder = @"输入手机号";
            textfield.keyboardType = UIKeyboardTypeNamePhonePad;
            self.phoneTextField = textfield;
        }else{
            UIButton * visiableBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
            visiableBtn.backgroundColor = [UIColor whiteColor];
            [visiableBtn setImage:[UIImage imageNamed:@"login_eye_nor"] forState:(UIControlStateNormal)];
            [visiableBtn setImage:[UIImage imageNamed:@"login_eye_hl"] forState:(UIControlStateSelected)];
            [visiableBtn addTarget:self action:@selector(clickPasswordRightBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            textfield.rightView = visiableBtn;
            textfield.rightViewMode = UITextFieldViewModeAlways;
            textfield.placeholder = @"输入登录密码";
            textfield.secureTextEntry = !self.isVisable;
            textfield.keyboardType = UIKeyboardTypeASCIICapable;
            self.passwordTextField = textfield;
        }
        textfield.textColor = [UIColor blackColor];
        textfield.delegate = self;
        textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        textfield.font = [UIFont systemFontOfSize:14.0];
        [self.loginBgView addSubview:textfield];
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(15, textfield.frame.size.height + textfield.frame.origin.y + 15 , kScreenWidth - 30, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self.loginBgView addSubview:lineView];
    }
    
    self.loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.loginBtn.frame = CGRectMake(15, recommandTitleLabel.frame.origin.y + recommandTitleLabel.frame.size.height + sizeHeight(350), kScreenWidth - 30, 58);
    self.loginBtn.backgroundColor = baseColor;
    self.loginBtn.layer.cornerRadius = 29;
    [self.loginBtn setTitle:@"登录" forState:(UIControlStateNormal)];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.loginBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
    [self.loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.loginBgView addSubview:self.loginBtn];
    
    UIButton * forgotBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    forgotBtn.frame = CGRectMake(self.loginBtn.frame.origin.x, self.loginBtn.frame.origin.y + self.loginBtn.frame.size.height + 12, 76, 14);
    [forgotBtn setTitle:@"忘记密码?" forState:(UIControlStateNormal)];
    [forgotBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    forgotBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    forgotBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    forgotBtn.tag = 100;
    [forgotBtn addTarget:self action:@selector(clickBottomBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.loginBgView addSubview:forgotBtn];
    
    UIButton * registerBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    registerBtn.frame = CGRectMake(kScreenWidth - 15 - 35, self.loginBtn.frame.origin.y + self.loginBtn.frame.size.height + 12, 35, 14);
    [registerBtn setTitle:@"注册" forState:(UIControlStateNormal)];
    [registerBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    registerBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    registerBtn.tag = 101;
    [registerBtn addTarget:self action:@selector(clickBottomBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.loginBgView addSubview:registerBtn];
    
    self.bottomHeight = kScreenHeight - registerBtn.frame.origin.y;
}

- (void)clickPasswordRightBtn:(UIButton *)btn{
    SSLog(@"click righbtn");
    self.isVisable = !self.isVisable;
    [btn setSelected:self.isVisable];
    self.passwordTextField.secureTextEntry = !self.isVisable;
}

- (void)clickLoginBtn{
    if (self.phoneTextField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"手机号码错误"];
        return;
    }
    
    if (!self.passwordTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
    
    NSDictionary * param = @{@"username":self.phoneTextField.text,@"password":self.passwordTextField.text};
    [httpTools post:LOGIN andParameters:param success:^(NSDictionary *dic) {
        SSLog(@"login:%@",dic);
        if ([dic[@"status"] isEqualToString:@"1"]) {
            NSDictionary * userDic = dic[@"data"][@"user"];
            [UserInfo saveUserAvatarWith:userDic[@"avatar"]];
            [UserInfo saveUserIDWith:userDic[@"id"]];
            [UserInfo saveUserTokenWith:dic[@"data"][@"user_token"]];
            [UserInfo saveUserNameWith:userDic[@"username"]];
            [UserInfo saveUserLevelWith:userDic[@"level"]];
            [UserInfo saveUserPublicWith:userDic[@"public"]];
            [UserInfo saveUserCreditWith:userDic[@"credit"]];
            [UserInfo saveUserPhoneNumberWith:self.phoneTextField.text];
            [UserInfo saveUserPasswordWith:self.passwordTextField.text];

            [UIApplication sharedApplication].keyWindow.rootViewController = [[SR_TabbarViewController alloc] init];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)clickOtherLoginBtn:(UIButton *)btn{
    SSLog(@"tag:%d",btn.tag);
}

- (void)clickBottomBtn:(UIButton *)btn{
    if (btn.tag == 100) {
        SR_ForgotPasswordViewController * forgotVC = [[SR_ForgotPasswordViewController alloc] init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:forgotVC];
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        SR_RegisterViewController * resterVC = [[SR_RegisterViewController alloc] init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:resterVC];
        [self presentViewController:nav animated:YES completion:nil];

    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    return YES;
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
        CGFloat diffHight = keyBoardRect.size.height > self.bottomHeight ? (keyBoardRect.size.height - self.bottomHeight) : 0;
        self.loginBgView.frame = CGRectMake(0, -diffHight, kScreenWidth, kScreenHeight);
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        self.loginBgView.frame = self.view.bounds;
    }];
    
}

@end
