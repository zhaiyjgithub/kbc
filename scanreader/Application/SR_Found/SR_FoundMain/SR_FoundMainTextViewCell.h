//
//  SR_FoundMainTextViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/7/21.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^foundMainTextViewCellBlock)(void);
typedef void(^foundMainTextViewCellInterBlock)(void);

@interface SR_FoundMainTextViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UILabel * bodyTextLabel;
@property(nonatomic,strong)UIImageView * subtitleImageView;
@property(nonatomic,strong)UIButton * subtitleButton;
@property(nonatomic,strong)UILabel * messageLabel;
@property(nonatomic,strong)UILabel * bookFriendsLabel;
@property(nonatomic,strong)UIButton * headerBtn;
@property(nonatomic,strong)foundMainTextViewCellBlock block;
@property(nonatomic,strong)foundMainTextViewCellInterBlock interBlock;
- (void)addBlock:(foundMainTextViewCellBlock)block;
- (void)addInterBlock:(foundMainTextViewCellInterBlock)interBlock;
@end
