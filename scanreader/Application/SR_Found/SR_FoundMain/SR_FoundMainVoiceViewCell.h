//
//  SR_FoundMainVoiceViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SR_BookClubBookNoteModel.h"

typedef void(^foundMainVoiceViewCellBlock)(void);
typedef void(^foundMainVoiceViewCellInterBlock)(void);
typedef void(^foundMainVoiceViewCellVoiceBtnBlock)(NSString * voiceUrl);

@interface SR_FoundMainVoiceViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UIButton * voiceBtn;
@property(nonatomic,strong)UIImageView * subtitleImageView;
@property(nonatomic,strong)UIButton * subtitleButton;
@property(nonatomic,strong)UILabel * messageLabel;
@property(nonatomic,strong)UILabel * bookFriendsLabel;
@property(nonatomic,strong)YYAnimatedImageView * headerImageView;
@property(nonatomic,strong)SR_BookClubBookNoteModel * noteModel;

@property(nonatomic,strong)foundMainVoiceViewCellBlock block;
@property(nonatomic,strong)foundMainVoiceViewCellInterBlock interBlock;
@property(nonatomic,strong)foundMainVoiceViewCellVoiceBtnBlock voiceBtnBlock;
- (void)addBlock:(foundMainVoiceViewCellBlock)block;
- (void)addInterBlock:(foundMainVoiceViewCellInterBlock)interBlock;
- (void)addVoiceBtnBlock:(foundMainVoiceViewCellVoiceBtnBlock)block;
@end
