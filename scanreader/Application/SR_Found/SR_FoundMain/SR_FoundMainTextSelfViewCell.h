//
//  SR_FoundMainTextSelfViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/7/21.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^foundMainTextSelfViewCellBlock)(void);
@interface SR_FoundMainTextSelfViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UILabel * bodyTextLabel;
@property(nonatomic,strong)UILabel * messageLabel;
@property(nonatomic,strong)UIButton * headerBtn;
@property(nonatomic,strong)foundMainTextSelfViewCellBlock  block;
- (void)addBlock:(foundMainTextSelfViewCellBlock )block;
@end
