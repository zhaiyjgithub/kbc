//
//  SR_NoteDetailPageImageViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/8/28.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SR_BookClubBookNoteModel.h"

typedef void(^noteDetailPageImageViewCellDeleteBtnBlock)(NSInteger tag);
typedef void(^noteDetailPageImageViewCellInterBtnBlock)(void);

@interface SR_NoteDetailPageImageViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UIImageView * subtitleImageView;
@property(nonatomic,strong)UIButton * subtitleButton;
@property(nonatomic,strong)UILabel * messageLabel;
@property(nonatomic,strong)UILabel * bookFriendsLabel;
@property(nonatomic,strong)UIImageView * messageImageView;
@property(nonatomic,strong)UIImageView * bookFriendsView;
@property(nonatomic,strong)UIView * imagebgView;
@property(nonatomic,strong)UILabel * noMoreVoiceTipsLabel;
@property(nonatomic,strong)NSMutableArray * resourceList;
@property(nonatomic,strong)noteDetailPageImageViewCellDeleteBtnBlock deleteBtnBlock;
@property(nonatomic,strong)noteDetailPageImageViewCellInterBtnBlock interBtnBlock;
@property(nonatomic,strong)SR_BookClubBookNoteModel * noteModel;
- (void)addDeleteBtnblock:(noteDetailPageImageViewCellDeleteBtnBlock)block;
- (void)addInterBtnBlock:(noteDetailPageImageViewCellInterBtnBlock)block;

@end
