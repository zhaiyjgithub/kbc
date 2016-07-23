//
//  SR_ScanResultNoneBookViewController.m
//  scanreader
//
//  Created by admin on 16/7/23.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_ScanResultNoneBookViewController.h"
#import "globalHeader.h"
#import "PhotoPickerTool.h"

@interface SR_ScanResultNoneBookViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UIButton * bookImageBtn;
@property(nonatomic,strong)UITextField * bookNameTextField;
@property(nonatomic,strong)UITextField * bookAuthorTextField;
@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,assign)CGFloat btnHeight;
@end

@implementation SR_ScanResultNoneBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"扫码结果";
    [self setupScanView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupScanView{
    self.bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBgView)];
    [self.bgView addGestureRecognizer:gesture];
    
    UILabel * tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 + sizeHeight(30), kScreenWidth, 16)];
    tipsLabel.text = @"该书暂无数据哦，即刻去创建该书吧！";
    tipsLabel.textColor = baseblackColor;
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [UIFont systemFontOfSize:16.0];
    [self.bgView addSubview:tipsLabel];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(15, tipsLabel.frame.origin.y + tipsLabel.frame.size.height + sizeHeight(30), kScreenWidth - 30, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView addSubview:lineView];
    
    self.bookImageBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.bookImageBtn.frame = CGRectMake(0, 0, 125, 150);
    self.bookImageBtn.center = CGPointMake(kScreenWidth/2, lineView.frame.origin.y + 75 + sizeHeight(38));
    self.bookImageBtn.backgroundColor = [UIColor grayColor];
    [self.bookImageBtn setTitle:@"上传封面" forState:(UIControlStateNormal)];
    [self.bookImageBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.bookImageBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
    [self.bookImageBtn addTarget:self action:@selector(clickBookImageBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:self.bookImageBtn];
    
    UIView * bookTextFieldLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, sizeHeight(58))];
    bookTextFieldLeftView.backgroundColor = [UIColor whiteColor];
    
    self.bookNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, self.bookImageBtn.frame.size.height + self.bookImageBtn.frame.origin.y + sizeHeight(45), kScreenWidth - 30, sizeHeight(58))];
    self.bookNameTextField.placeholder = @"请输入书名";
    self.bookNameTextField.textColor = baseblackColor;
    self.bookNameTextField.layer.borderWidth = 1.0;
    self.bookNameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.bookNameTextField.layer.cornerRadius = 2.0;
    self.bookNameTextField.delegate = self;
    self.bookNameTextField.leftView = bookTextFieldLeftView;
    self.bookNameTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.bgView addSubview:self.bookNameTextField];
    
    
    UIView * bookAuthorTextFieldLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, sizeHeight(58))];
    bookAuthorTextFieldLeftView.backgroundColor = [UIColor whiteColor];
    
    self.bookAuthorTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, self.bookNameTextField.frame.size.height + self.bookNameTextField.frame.origin.y + sizeHeight(22), kScreenWidth - 30, sizeHeight(58))];
    self.bookAuthorTextField.placeholder = @"请输入作者";
    self.bookAuthorTextField.textColor = baseblackColor;
    self.bookAuthorTextField.layer.borderWidth = 1.0;
    self.bookAuthorTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.bookAuthorTextField.layer.cornerRadius = 2.0;
    self.bookAuthorTextField.delegate = self;
    self.bookAuthorTextField.leftViewMode = UITextFieldViewModeAlways;
    self.bookAuthorTextField.leftView = bookAuthorTextFieldLeftView;
    [self.bgView addSubview:self.bookAuthorTextField];
    
    UIButton * createBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    createBtn.frame = CGRectMake(15, self.bookAuthorTextField.frame.origin.y + self.bookAuthorTextField.frame.size.height + sizeHeight(34), kScreenWidth - 30, sizeHeight(58));
    createBtn.backgroundColor = baseColor;
    [createBtn setTitle:@"创建读书会" forState:(UIControlStateNormal)];
    [createBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [createBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
    createBtn.layer.cornerRadius = 15.0;
    [createBtn addTarget:self action:@selector(clickCreateBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:createBtn];
    self.btnHeight = createBtn.frame.origin.y + createBtn.frame.size.height + 3;
}

- (void)clickBookImageBtn{
    __weak typeof(self) weakSelf = self;
    [[PhotoPickerTool sharedPhotoPickerTool] showOnPickerViewControllerSourceType:(UIImagePickerControllerSourceTypeCamera) onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
        [weakSelf.bookImageBtn setImage:image forState:(UIControlStateNormal)];
        [weakSelf.bookImageBtn setTitle:@"" forState:(UIControlStateNormal)];
    }];
}

- (void)clickCreateBtn{
    
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
    [UIView animateWithDuration:animationDuration animations:^{
        CGFloat createBtnHeightFromBottom = kScreenHeight - self.btnHeight;
        if (createBtnHeightFromBottom < keyBoardRect.size.height) {
            CGFloat diffHeight = keyBoardRect.size.height - createBtnHeightFromBottom;
            self.bgView.frame = CGRectMake(0, -diffHeight, kScreenWidth, kScreenHeight);
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.bgView.frame = self.view.bounds;
    } completion:^(BOOL finished) {
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    return YES;
}

- (void)clickBgView{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}


@end
