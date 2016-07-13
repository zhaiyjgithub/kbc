//
//  SR_FoundMainViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^foundMainImageViewCellBlock)(void);

@interface SR_FoundMainImageViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UIImageView * recordImageView;
@property(nonatomic,strong)UIImageView * subtitleImageView;
@property(nonatomic,strong)UILabel * subtitleLabel;
@property(nonatomic,strong)UILabel * messageAndMembersLabel;
@property(nonatomic,strong)UIButton * headerBtn;
@property(nonatomic,strong)foundMainImageViewCellBlock block;
- (void)addBlock:(foundMainImageViewCellBlock)block;
@end
