//
//  SR_FoundMainViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SR_BookClubBookNoteModel.h"
#import "SR_PreScanView.h"

typedef void(^foundMainImageViewCellBlock)(void);
typedef void(^foundMainImageViewCellInterBlock)(void);
typedef void(^foundMainImageViewCellImageBlock)(NSString * imagePath);

@interface SR_FoundMainImageViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)YYAnimatedImageView * recordImageView;
@property(nonatomic,strong)UIImageView * subtitleImageView;
@property(nonatomic,strong)UIButton * subtitleButton;
@property(nonatomic,strong)UILabel * messageLabel;
@property(nonatomic,strong)UILabel * bookFriendsLabel;
@property(nonatomic,strong)YYAnimatedImageView * headerImageView;
@property(nonatomic,strong)SR_BookClubBookNoteModel * noteModel;
@property(nonatomic,strong)foundMainImageViewCellBlock block;
@property(nonatomic,strong)foundMainImageViewCellInterBlock interBlock;
@property(nonatomic,strong)foundMainImageViewCellImageBlock imageBlock;
- (void)addBlock:(foundMainImageViewCellBlock)block;
- (void)addInterBlock:(foundMainImageViewCellInterBlock)interBlock;
- (void)addImageBlock:(foundMainImageViewCellImageBlock)imageBlock;
@end
