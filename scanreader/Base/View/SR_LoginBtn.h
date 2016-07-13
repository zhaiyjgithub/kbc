//
//  SR_LoginBtn.h
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, BaseButtonType) {
    BaseButtonTypeCenter,
    BaseButtonTypeDefault,
};


@interface SR_LoginBtn : UIButton
@property(nonatomic,assign)BaseButtonType type;
- (instancetype)initWithType:(BaseButtonType)type;
@end
