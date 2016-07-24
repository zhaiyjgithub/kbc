//
//  SR_ActionSheetImageView.m
//  scanreader
//
//  Created by admin on 16/7/24.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_ActionSheetImageView.h"
#import "globalHeader.h"
#import <SVProgressHUD.h>
#import "SR_ActionSheetImageCollectionViewCell.h"
#import "SR_ActionSheetImageLayout.h"
#import "PhotoPickerTool.h"

static NSString *const cellID = @"DD_MyCollectionViewCell";

@implementation SR_ActionSheetImageView

- (id)initActionSheetWith:(NSString *)title images:(NSArray *)images viewController:(UIViewController *)viewController{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        self.articleTitle = title;
        [self.articleImages addObjectsFromArray:images];
        self.viewController = viewController;
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
    
    SR_ActionSheetImageLayout * layout = [[SR_ActionSheetImageLayout alloc] init];
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, self.titleTextField.frame.origin.y + self.titleTextField.frame.size.height + sizeHeight(10), kScreenWidth - 30, sizeHeight(260)) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = kColor(0xf3, 0xf3, 0xf3);
    [collectionView registerClass:[SR_ActionSheetImageCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    
    self.collectionView = collectionView;
    [self addSubview:collectionView];

    self.sendBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.sendBtn.frame = CGRectMake(kScreenWidth - 15 - 44, self.collectionView.frame.origin.y + self.collectionView.frame.size.height + sizeHeight(10), 44, sizeHeight(44) );
    [self.sendBtn setTitle:@"完成" forState:(UIControlStateNormal)];
    [self.sendBtn setTitleColor:baseColor forState:(UIControlStateNormal)];
    [self.sendBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
    [self.sendBtn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.sendBtn];
    
    self.takePhotoTypeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.takePhotoTypeBtn.frame = CGRectMake(15, self.sendBtn.frame.origin.y, 44, sizeHeight(44));
    [self.takePhotoTypeBtn setTitle:@"拍照" forState:(UIControlStateNormal)];
    [self.takePhotoTypeBtn setTitleColor:baseColor forState:(UIControlStateNormal)];
    [self.takePhotoTypeBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
    [self.takePhotoTypeBtn addTarget:self action:@selector(clickPhotoBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    self.takePhotoTypeBtn.tag = 100;
    [self addSubview:self.takePhotoTypeBtn];
    
    self.cameraLibraryTypeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.cameraLibraryTypeBtn.frame = CGRectMake(15 + self.takePhotoTypeBtn.frame.origin.x + self.takePhotoTypeBtn.frame.size.width, self.sendBtn.frame.origin.y, 100, sizeHeight(44));
    [self.cameraLibraryTypeBtn setTitle:@"相册" forState:(UIControlStateNormal)];
    [self.cameraLibraryTypeBtn setTitleColor:baseColor forState:(UIControlStateNormal)];
    [self.cameraLibraryTypeBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
    [self.cameraLibraryTypeBtn addTarget:self action:@selector(clickPhotoBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    self.cameraLibraryTypeBtn.tag = 101;
    [self addSubview:self.cameraLibraryTypeBtn];
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
   
}

- (void)clickPhotoBtn:(UIButton *)btn{
    self.handerView.enabled = NO;
    self.handerView.hidden = YES;
    self.hidden = YES;
    if (btn.tag == 100) {//相机
        [[PhotoPickerTool sharedPhotoPickerTool] showOnPickerViewControllerSourceType:(UIImagePickerControllerSourceTypeCamera) onViewController:self.viewController compled:^(UIImage *image, NSDictionary *editingInfo) {
        }];
    }else{
        [[PhotoPickerTool sharedPhotoPickerTool] showOnPickerViewControllerSourceType:(UIImagePickerControllerSourceTypePhotoLibrary) onViewController:self.viewController compled:^(UIImage *image, NSDictionary *editingInfo) {
            self.handerView.enabled = YES;
            self.handerView.hidden = NO;
            self.hidden = NO;
        }];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SR_ActionSheetImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    return cell;
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
        self.frame = CGRectMake(0, kScreenHeight - sizeHeight(400) - keyBoardRect.size.height/2, kScreenWidth, kScreenHeight);
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

- (NSMutableArray *)articleImages{
    if (!_articleImages) {
        _articleImages = [[NSMutableArray alloc] init];
    }
    return _articleImages;
}

@end
