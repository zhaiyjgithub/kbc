//
//  SR_FoundMainCollectionViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SR_BookClubBookNoteModel.h"

typedef void(^foundMainCollectionViewCellBlock)(void);
typedef void(^foundMainCollectionViewCellInterBlock)(void);

@interface SR_FoundMainCollectionViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UIButton * voiceBtn;
@property(nonatomic,strong)UIImageView * subtitleImageView;
@property(nonatomic,strong)UIButton * subtitleButton;
@property(nonatomic,strong)UILabel * messageLabel;
@property(nonatomic,strong)UILabel * bookFriendsLabel;
@property(nonatomic,strong)YYAnimatedImageView * headerImageView;
@property(nonatomic,strong)SR_BookClubBookNoteModel * noteModel;
@property(nonatomic,strong)foundMainCollectionViewCellInterBlock  interBlock;
@property(nonatomic,strong)foundMainCollectionViewCellBlock block;
- (void)addBlock:(foundMainCollectionViewCellBlock)block;
- (void)addInterBlock:(foundMainCollectionViewCellInterBlock)addInterBlockBlock;
@end
