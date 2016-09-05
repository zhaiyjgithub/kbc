//
//  SR_NoteDetailPageTextViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/8/28.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SR_BookClubBookNoteModel.h"

typedef void(^noteDetailPageTextViewCellInterBlock)(void);

@interface SR_NoteDetailPageTextViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UILabel * bodyTextLabel;
@property(nonatomic,strong)UIImageView * subtitleImageView;
@property(nonatomic,strong)UIButton * subtitleButton;
@property(nonatomic,strong)UILabel * messageLabel;
@property(nonatomic,strong)UILabel * bookFriendsLabel;
@property(nonatomic,strong)UIImageView * messageImageView;
@property(nonatomic,strong)UIImageView * bookFriendsView;
@property(nonatomic,strong)SR_BookClubBookNoteModel * noteModel;
@property(nonatomic,strong)noteDetailPageTextViewCellInterBlock interBtnBlock;
- (void)addInterBtnBlock:(noteDetailPageTextViewCellInterBlock)block;
@end
