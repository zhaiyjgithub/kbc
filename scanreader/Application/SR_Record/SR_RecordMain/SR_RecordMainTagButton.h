//
//  SR_RecordMainTagButton.h
//  scanreader
//
//  Created by jbmac01 on 16/7/21.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SR_RecordMainTagButton : UIButton
@property(nonatomic,assign)float width;
@property(nonatomic,assign)float height;
- (instancetype)initWithLength:(float)width height:(CGFloat)height;
@end
