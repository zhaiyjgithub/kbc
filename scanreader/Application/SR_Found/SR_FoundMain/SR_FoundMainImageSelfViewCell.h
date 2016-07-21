//
//  SR_FoundMainImageSelfViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/7/21.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^foundMainImageSelfViewCellBlock)(void);

@interface SR_FoundMainImageSelfViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UIImageView * recordImageView;
@property(nonatomic,strong)UILabel * messageLabel;
@property(nonatomic,strong)UIButton * headerBtn;
@property(nonatomic,strong)foundMainImageSelfViewCellBlock  block;
- (void)addBlock:(foundMainImageSelfViewCellBlock )block;
@end
