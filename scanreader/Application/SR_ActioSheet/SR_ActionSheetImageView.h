//
//  SR_ActionSheetImageView.h
//  scanreader
//
//  Created by admin on 16/7/24.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol imageViewSendBtnDelegate <NSObject>

@optional
- (void)clickImageViewSendBtn:(NSString *)title images:(NSArray *)images;
@end

@interface SR_ActionSheetImageView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UIButton * handerView;
@property(nonatomic,weak)id<imageViewSendBtnDelegate>delegate;
@property(nonatomic,copy)NSString * articleTitle;
@property(nonatomic,strong)NSMutableArray * articleImages;
@property(nonatomic,strong)UIViewController * viewController;
@property(nonatomic,strong)UITextField * titleTextField;
@property(nonatomic,strong)UIButton * sendBtn;
@property(nonatomic,strong)UIButton * cameraLibraryTypeBtn;
@property(nonatomic,strong)UIButton * takePhotoTypeBtn;
@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,copy)NSString * noteId;
@property(nonatomic,copy)NSString * book_id;
@property(nonatomic,copy)NSString * requestType;
- (id)initActionSheetWith:(NSString *)title images:(NSArray *)images viewController:(UIViewController *)viewController;
- (void)show;
- (void)dismiss;

@end
