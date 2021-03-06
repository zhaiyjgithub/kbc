//
//  SR_NoteDetailPageVoiceViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/8/30.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SR_BookClubBookNoteModel.h"

typedef void(^noteDetailPageVoiceViewCellVoiceBtnBlock)(NSString * filePath,UIButton * voiceBtn,float voiceTimeLength);
typedef void(^noteDetailPageVoiceViewCellDeleteBtnBlock)(NSInteger tag);
typedef void(^noteDetailPageVoiceViewCellInterBtnBlock)(void);

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
@property(nonatomic,assign)float voiceTimeLength;
@property(nonatomic,strong)SR_BookClubBookNoteModel * noteModel;
@property(nonatomic,strong)NSMutableArray * resourceList;
@property(nonatomic,strong)UILabel * noMoreVoiceTipsLabel;
@property(nonatomic,strong)noteDetailPageVoiceViewCellVoiceBtnBlock voiceBtnblock;
@property(nonatomic,strong)noteDetailPageVoiceViewCellDeleteBtnBlock deleteBtnBlock;
@property(nonatomic,strong)noteDetailPageVoiceViewCellInterBtnBlock interBtnBlock;
- (void)addVoicBtnblock:(noteDetailPageVoiceViewCellVoiceBtnBlock)block;
- (void)addDeleteBtnblock:(noteDetailPageVoiceViewCellDeleteBtnBlock)block;
- (void)addInterBtnBlock:(noteDetailPageVoiceViewCellInterBtnBlock)block;

@end
