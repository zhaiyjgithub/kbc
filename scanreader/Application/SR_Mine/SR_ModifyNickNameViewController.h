//
//  SR_ModifyNickNameViewController.h
//  scanreader
//
//  Created by jbmac01 on 16/9/3.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol modifyNickNameViewControllerDelegate <NSObject>

@optional
- (void)updateNickName;

@end
@interface SR_ModifyNickNameViewController : UIViewController
@property(nonatomic,weak)id<modifyNickNameViewControllerDelegate>delegate;
@end
