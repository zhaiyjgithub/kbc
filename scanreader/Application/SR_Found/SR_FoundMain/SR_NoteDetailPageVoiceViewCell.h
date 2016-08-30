//
//  SR_NoteDetailPageVoiceViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/8/30.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SR_BookClubBookNoteModel.h"

typedef void(^noteDetailPageVoiceViewCellVoiceBtnBlock)(NSString * filePath);

@interface SR_NoteDetailPageVoiceViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UIImageView * subtitleImageView;
@property(nonatomic,strong)UIButton * subtitleButton;
@property(nonatomic,strong)UILabel * messageLabel;
@property(nonatomic,strong)UILabel * bookFriendsLabel;
@property(nonatomic,strong)UIImageView * messageImageView;
@property(nonatomic,strong)UIImageView * bookFriendsView;
@property(nonatomic,strong)UIView * voicebgView;
@property(nonatomic,strong)SR_BookClubBookNoteModel * noteModel;
@property(nonatomic,strong)NSMutableArray * resourceList;
@property(nonatomic,strong)noteDetailPageVoiceViewCellVoiceBtnBlock voiceBtnblock;
- (void)addVoicBtnblock:(noteDetailPageVoiceViewCellVoiceBtnBlock)block;
@end
