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
#import <MBProgressHUD.h>
#import "UserInfo.h"
#import "requestAPI.h"
#import "httpTools.h"
#import <JFImagePickerController.h>

#define ALERT_VIEW_TAG_DISMIESS (-1)

static NSString *const cellID = @"SR_ActionSheetImageViewCollectionViewCell";

@interface SR_ActionSheetImageView ()<UIAlertViewDelegate,JFImagePickerDelegate>
@end

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
    self.titleTextField.layer.cornerRadius = 3.0;
    self.titleTextField.delegate = self;
    self.titleTextField.leftViewMode = UITextFieldViewModeAlways;
    self.titleTextField.leftView = leftView;
    [self addSubview:self.titleTextField];
    
    SR_ActionSheetImageLayout * layout = [[SR_ActionSheetImageLayout alloc] init];
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, self.titleTextField.frame.origin.y + self.titleTextField.frame.size.height + sizeHeight(10), kScreenWidth - 30, sizeHeight(260)) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    collectionView.layer.cornerRadius  = 3.0;
    [collectionView registerClass:[SR_ActionSheetImageCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    
    self.collectionView = collectionView;
    [self addSubview:collectionView];

    self.sendBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.sendBtn.frame = CGRectMake(kScreenWidth - 15 - 44, self.collectionView.frame.origin.y + self.collectionView.frame.size.height + sizeHeight(10), 44, sizeHeight(44) );
    [self.sendBtn setTitle:@"发送" forState:(UIControlStateNormal)];
    [self.sendBtn setTitleColor:baseColor forState:(UIControlStateNormal)];
    [self.sendBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
    [self.sendBtn addTarget:self action:@selector(clickSendBtn:) forControlEvents:(UIControlEventTouchUpInside)];
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
    [_handerView addTarget:self action:@selector(clickHandleView) forControlEvents:(UIControlEventTouchUpInside)];
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

- (void)clickHandleView{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否放弃已编辑的内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = ALERT_VIEW_TAG_DISMIESS;
    [alertView show];
}

- (void)clickSendBtn:(UIButton *)btn{
    if (!self.titleTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入标题"];
        return;
    }
    if (!self.articleImages.count) {
        [SVProgressHUD showErrorWithStatus:@"请添加图片"];
        return;
    }
    //发起请求
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    NSDictionary * baseparam = @{@"user_id":userId,@"user_token":userToken,@"type":NOTE_TYPE_PIX,
                             @"title":self.titleTextField.text};
    NSMutableDictionary * param = [[NSMutableDictionary alloc] initWithDictionary:baseparam];
    NSString * baseUrl = SAVE_NOTE;
    if ([self.requestType isEqualToString:NOTE_REQUSERT_TYPE_SAVE]) {
        if (self.book_id) {//创建有对象
            param[@"book_id"] = self.book_id;
        }
    }else if ([self.requestType isEqualToString:NOTE_REQUSERT_TYPE_UPDATE]){
        baseUrl = UPDATE_NOTE;
        if (self.noteId) {//更新笔记
            param[@"id"] = self.noteId;
        }
    }else if ([self.requestType isEqualToString:NOTE_REQUSERT_TYPE_SAVE_PAGE]){
        baseUrl = SAVE_NOTE;
        if (self.page_id) {
            param[@"page_id"] = self.page_id;
        }
    }

    //这里的提示不起作用，用户可能会重复点发送按钮，
    MBProgressHUD * hud = [[MBProgressHUD  alloc] initWithView:self.handerView];
    [hud showAnimated:YES];
    [btn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    btn.enabled = NO;
    [httpTools uploadImage:baseUrl parameters:param images:self.articleImages success:^(NSDictionary *dic) {
        [btn setTitleColor:baseColor forState:(UIControlStateNormal)];
        btn.enabled = YES;
        SSLog(@"save pic:%@",dic);
        [hud hideAnimated:YES];
        if ([dic[@"show"] isEqualToString:@"1"]) {
            [SVProgressHUD showSuccessWithStatus:dic[@"msg"]];
        }
        //上传成功回调
        if ([self.delegate conformsToProtocol:@protocol(imageViewSendBtnDelegate)] && [self.delegate respondsToSelector:@selector(clickImageViewSendBtn:images:)]) {
            [self.delegate clickImageViewSendBtn:self.titleTextField.text images:self.articleImages];
        }
        [self dismiss];
    } failure:^(NSError *error) {
        [btn setTitleColor:baseColor forState:(UIControlStateNormal)];
        btn.enabled = YES;
        [hud hideAnimated:YES];
        [SVProgressHUD showErrorWithStatus:@"笔记创建失败"];
    }];
}

- (void)clickPhotoBtn:(UIButton *)btn{
    self.handerView.enabled = NO;
    self.handerView.hidden = YES;
    self.hidden = YES;
    if (btn.tag == 100) {//相机
        [[PhotoPickerTool sharedPhotoPickerTool] showOnPickerViewControllerSourceType:(UIImagePickerControllerSourceTypeCamera) onViewController:self.viewController compled:^(UIImage *image, NSDictionary *editingInfo) {
            self.handerView.enabled = YES;
            self.handerView.hidden = NO;
            self.hidden = NO;
            [self.articleImages addObject:image];
            [self.collectionView reloadData];
//            NSIndexPath * indexpath = [NSIndexPath indexPathForRow:self.articleImages.count - 1 inSection:0];
//            [self.collectionView insertItemsAtIndexPaths:@[indexpath]];
//            [self.collectionView scrollToItemAtIndexPath:indexpath atScrollPosition:(UICollectionViewScrollPositionBottom) animated:YES];
        } cancel:^{
            self.handerView.enabled = YES;
            self.handerView.hidden = NO;
            self.hidden = NO;
        }];
    }else{
//        [[PhotoPickerTool sharedPhotoPickerTool] showOnPickerViewControllerSourceType:(UIImagePickerControllerSourceTypePhotoLibrary) onViewController:self.viewController compled:^(UIImage *image, NSDictionary *editingInfo) {
//            self.handerView.enabled = YES;
//            self.handerView.hidden = NO;
//            self.hidden = NO;
//            [self.articleImages addObject:image];
//            
//            NSIndexPath * indexpath = [NSIndexPath indexPathForRow:self.articleImages.count - 1 inSection:0];
//            [self.collectionView insertItemsAtIndexPaths:@[indexpath]];
//            [self.collectionView scrollToItemAtIndexPath:indexpath atScrollPosition:(UICollectionViewScrollPositionBottom) animated:YES];
//        }];
        //跳转到图库
        [self pickPhotos];
    }
}

- (void)pickPhotos{
    JFImagePickerController *picker = [[JFImagePickerController alloc] initWithRootViewController:self.viewController];
    picker.pickerDelegate = self;
    [self.viewController presentViewController:picker animated:YES completion:nil];
}

#pragma mark - ImagePicker Delegate

- (void)imagePickerDidFinished:(JFImagePickerController *)picker{
    for (ALAsset *asset in picker.assets) {
        [[JFImageManager sharedManager] thumbWithAsset:asset resultHandler:^(UIImage *result) {
            SSLog(@"image size:%@",NSStringFromCGSize(result.size));
            if (result.size.height != 75) {
                [self.articleImages addObject:result];
                SSLog(@"images count:%d",self.articleImages.count);
                [self imagePickerDidCancel:picker];
                self.handerView.enabled = YES;
                self.handerView.hidden = NO;
                self.hidden = NO;
                [self.collectionView reloadData];
            }
        }];
    }
    
}

- (void)imagePickerDidCancel:(JFImagePickerController *)picker{
    self.handerView.enabled = YES;
    self.handerView.hidden = NO;
    self.hidden = NO;
    [self.collectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.articleImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SR_ActionSheetImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.noteImageView.image = self.articleImages[indexPath.row];
    __weak typeof(self) weakSelf = self;
    [cell addBlock:^{
        [weakSelf longNoteImageViewEvent:indexPath.row];
    }];
    return cell;
}

- (void)longNoteImageViewEvent:(NSInteger)row{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除该图片吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = row;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == ALERT_VIEW_TAG_DISMIESS) {
        if (buttonIndex == 1) {
            [self.articleImages removeAllObjects];
            [self dismiss];
        }
    }else{
        if (buttonIndex == 1) {
            NSInteger row = alertView.tag;
            NSIndexPath * indexpath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.articleImages removeObjectAtIndex:row];
            [self.collectionView deleteItemsAtIndexPaths:@[indexpath]];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }

    }
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
