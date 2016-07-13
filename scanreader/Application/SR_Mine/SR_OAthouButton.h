//
//  SR_OAthouButton.h
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BaseButtonType) {
    BaseButtonTypeCenter,
    BaseButtonTypeDefault,
    BaseButtonTypeLeft,
};

typedef NS_ENUM(NSInteger, BaseButtonSizeType) {
    BaseButtonSizeTypeSmall,
    BaseButtonSizeTypeLarge,
    
};

@interface SR_OAthouButton : UIButton
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,assign)NSInteger sizeType;
- (instancetype)initWithType:(BaseButtonType)type sizeType:(BaseButtonSizeType)sizeType;

@end
