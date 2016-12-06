//
//  SR_FoundMainVoiceViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_FoundMainVoiceViewCell.h"
#import "globalHeader.h"
#import "NSDate+JJ.h"

@implementation SR_FoundMainVoiceViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth - 30 - 75, 17)];
    self.titleLabel.text = @"笔记标题";
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 75,15,75,16)];
    self.timeLabel.text = @"06-28";
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.timeLabel];
    
    UIView * barView = [[UIView alloc] initWithFrame:CGRectMake(18, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 22, 210, 14)];
    barView.backgroundColor = kColor(215, 215, 215);
    barView.layer.cornerRadius = 7.0;
    self.barView = barView;
    barView.hidden = YES;
    [self.contentView addSubview:barView];
    
    self.voiceProgressView = [[UIView alloc] initWithFrame:CGRectMake(barView.frame.origin.x, barView.frame.origin.y, 1, barView.frame.size.height)];
    self.voiceProgressView.backgroundColor = kColor(215, 215, 215);
    self.voiceProgressView.layer.cornerRadius = 7.0;
    [self.contentView addSubview:self.voiceProgressView];
    
    self.voiceBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.voiceBtn.frame = CGRectMake(0, 0, 40, 40);
    self.voiceBtn.center = CGPointMake(barView.frame.origin.x + barView.frame.size.width/2, barView.frame.origin.y + barView.frame.size.height/2);
    self.voiceBtn.backgroundColor = baseColor;
    self.voiceBtn.layer.cornerRadius = 20;
    [self.voiceBtn addTarget:self action:@selector(clickVoiceBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.voiceBtn setTitle:@"语音" forState:(UIControlStateNormal)];
    self.voiceBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    self.voiceBtn.hidden = YES;
    [self.contentView addSubview:self.voiceBtn];
    
    UILabel * noMoreVoiceTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, barView.frame.size.width, 16)];
    noMoreVoiceTipsLabel.center = barView.center;
    noMoreVoiceTipsLabel.text = @"没有更多语音笔记，点击添加语音笔记";
    noMoreVoiceTipsLabel.textColor = [UIColor lightGrayColor];
    noMoreVoiceTipsLabel.font = [UIFont systemFontOfSize:14.0];
    noMoreVoiceTipsLabel.textAlignment = NSTextAlignmentLeft;
    noMoreVoiceTipsLabel.numberOfLines = 0;
    self.noMoreVoiceTipsLabel = noMoreVoiceTipsLabel;
    [self.contentView addSubview:noMoreVoiceTipsLabel];
    
    
    self.subtitleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.voiceBtn.frame.origin.y + self.voiceBtn.frame.size.height + 11, 19, 19)];
    self.subtitleImageView.image = [UIImage imageNamed:@"fx_book"];
    [self.contentView addSubview:self.subtitleImageView];
    
    self.subtitleButton = [[UIButton alloc] initWithFrame:CGRectMake(self.subtitleImageView.frame.origin.x + self.subtitleImageView.frame.size.width + 5, self.subtitleImageView.frame.origin.y, 200, 19)];
    [self.subtitleButton setTitle:@"《论语》第十二页" forState:(UIControlStateNormal)];
    [self.subtitleButton setTitleColor:baseColor forState:(UIControlStateNormal)];
    [self.subtitleButton setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
    self.subtitleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.subtitleButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [self.subtitleButton addTarget:self action:@selector(clickInterBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:self.subtitleButton];
    
    
    UIImageView * messageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.subtitleButton.frame.origin.y + self.subtitleButton.frame.size.height + 10, 17, 17)];
    messageImageView.image = [UIImage imageNamed:@"fx_hd"];
    [self.contentView addSubview:messageImageView];
    
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(messageImageView.frame.origin.x + messageImageView.frame.size.width + 10, messageImageView.frame.origin.y, 64, 17)];
    self.messageLabel.text = @"互动(20)";
    self.messageLabel.textColor = baseblackColor;
    self.messageLabel.textAlignment = NSTextAlignmentLeft;
    self.messageLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.messageLabel];
    
    UIImageView * bookFriendsView = [[UIImageView alloc] initWithFrame:CGRectMake(self.messageLabel.frame.origin.x + self.messageLabel.frame.size.width + 25, self.messageLabel.frame.origin.y, 17, 17)];
    bookFriendsView.image = [UIImage imageNamed:@"fx_twoman"];
    [self.contentView addSubview:bookFriendsView];
    
    self.bookFriendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(bookFriendsView.frame.origin.x + bookFriendsView.frame.size.width + 10, bookFriendsView.frame.origin.y, 64, 17)];
    self.bookFriendsLabel.text = @"读友(85)";
    self.bookFriendsLabel.textColor = baseblackColor;
    self.bookFriendsLabel.textAlignment = NSTextAlignmentLeft;
    self.bookFriendsLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.bookFriendsLabel];
    
    self.headerImageView = [[YYAnimatedImageView alloc] init];
    [self.headerImageView setImageWithURL:nil placeholder:[UIImage imageNamed:@"headerIcon"]];
    self.headerImageView.frame = CGRectMake(0, 0, 48, 48);
    self.headerImageView.center = CGPointMake(kScreenWidth - 36, 71);
    self.headerImageView.layer.cornerRadius = 24;
    self.headerImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.headerImageView];
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeaderBtn)];
    self.headerImageView.userInteractionEnabled = YES;
    [self.headerImageView addGestureRecognizer:gesture];
}

- (void)setNoteModel:(SR_BookClubBookNoteModel *)noteModel{
    _noteModel = noteModel;
    self.titleLabel.text = noteModel.title;
    NSDate * createData = [NSDate dateWithTimeIntervalSince1970:noteModel.time_create];
    NSString * time = [NSDate compareCurrentTime:createData];//[NSDate getRealDateTime:createData withFormat:@"yyyy-MM-dd HH:mm"];
    self.timeLabel.text = time;
    [self.subtitleButton setTitle:noteModel.page.title forState:(UIControlStateNormal)];
    self.messageLabel.text = [NSString stringWithFormat:@"互动(%@)",noteModel.note_total];
    self.bookFriendsLabel.text = [NSString stringWithFormat:@"读友(%@)",noteModel.member_total];
    [self.headerImageView setImageWithURL:[NSURL URLWithString:noteModel.user.avatar] placeholder:[UIImage imageNamed:@"headerIcon"]];
    
    NSString * voiceFileSize = [self.noteModel.resourceList firstObject][@"filesize"];
    self.voiceTimeLength = (voiceFileSize.floatValue/1024.0/23.0 - 1.3) < 0.9 ? 0: (voiceFileSize.floatValue/1024.0/23.0 - 1.3);//模拟计算语音时长
  //  SSLog(@"title:%@ filesize:%@ length:%0.1f  url:%@",self.noteModel.title,voiceFileSize,voiceLength,[self.noteModel.resourceList firstObject][@"path"]);
    
    NSString * voiceUrl = [self.noteModel.resourceList firstObject][@"path"];
    AVPlayer * avplayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:voiceUrl]];
    CMTime duartion = avplayer.currentItem.asset.duration;
    float seconds = CMTimeGetSeconds(duartion);
    self.voiceTimeLength = seconds + 1;
    
    [self.voiceBtn setTitle:[NSString stringWithFormat:@"%.0fs",self.voiceTimeLength] forState:(UIControlStateNormal)];
    if (!noteModel.page && !noteModel.book) { //没有互动页或者读书标题
        self.subtitleImageView.hidden = YES;
        self.subtitleButton.hidden = YES;
    }else{
        self.subtitleImageView.hidden = NO;
        self.subtitleButton.hidden = NO;
        if (noteModel.page) {
            [self.subtitleButton setTitle:noteModel.page.title forState:(UIControlStateNormal)];
        }else{
            [self.subtitleButton setTitle:noteModel.book.title forState:(UIControlStateNormal)];
        }
        
    }
    
    if (self.noteModel.resourceList.count) {
        self.barView.hidden = NO;
        self.voiceBtn.hidden = NO;
        self.noMoreVoiceTipsLabel.hidden = YES;
    }else{
        self.barView.hidden = YES;
        self.voiceBtn.hidden = YES;
        self.noMoreVoiceTipsLabel.hidden = NO;
    }
}

- (void)clickVoiceBtn{
    if (self.voiceBtnBlock) {
        self.voiceBtnBlock([self.noteModel.resourceList firstObject][@"path"],self.voiceTimeLength);
    }
}

- (void)addVoiceBtnBlock:(foundMainVoiceViewCellVoiceBtnBlock)block{
    self.voiceBtnBlock = block;
}

- (void)clickHeaderBtn{
    if (self.block) {
        self.block();
    }
}

- (void)addBlock:(foundMainVoiceViewCellBlock)block{
    self.block = block;
}

- (void)clickInterBtn{
    if (self.interBlock) {
        self.interBlock();
    }
}

- (void)addInterBlock:(foundMainVoiceViewCellInterBlock)interBlock{
    self.interBlock = interBlock;
}

@end
