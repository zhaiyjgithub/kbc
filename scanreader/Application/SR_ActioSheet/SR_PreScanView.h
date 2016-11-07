//
//  PreScanView.h
//  scanreader
//
//  Created by jbmac01 on 16/10/24.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SR_PreScanView : UIView
@property(nonatomic,strong)UIButton * handerView;
@property(nonatomic,copy)NSString * imagePath;
@property(nonatomic,strong)UIImageView * preScanImageView;
- (id)initPreScanViewWithImagePath:(NSString *)imagePath;

- (void)show;
- (void)dismiss;
@end
