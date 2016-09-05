//
//  SR_NoteDetailPageVoiceViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/8/30.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_NoteDetailPageVoiceViewCell.h"
#import "globalHeader.h"
#import "NSDate+JJ.h"
#import "NSString+JJ.h"


@implementation SR_NoteDetailPageVoiceViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 125, 15)];
    self.titleLabel.text = @"笔记标题";
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 8,120,16)];
    self.timeLabel.text = @"2016-06-28 12:30";
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.timeLabel];
    
    self.voicebgView = [[UIView alloc] initWithFrame:CGRectMake(15, self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height + 8,(kScreenWidth - 30), 90)];
    self.voicebgView.backgroundColor = [UIColor whiteColor];
    self.voicebgView.hidden = YES;
    [self.contentView addSubview:self.voicebgView];
    
    UILabel * noMoreVoiceTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.voicebgView.frame.origin.y, self.voicebgView.frame.size.width, 16)];
    noMoreVoiceTipsLabel.text = @"没有更多语音笔记，点击右上角添加语音笔记";
    noMoreVoiceTipsLabel.textColor = [UIColor lightGrayColor];
    noMoreVoiceTipsLabel.font = [UIFont systemFontOfSize:14.0];
    noMoreVoiceTipsLabel.textAlignment = NSTextAlignmentLeft;
    noMoreVoiceTipsLabel.numberOfLines = 0;
    self.noMoreVoiceTipsLabel = noMoreVoiceTipsLabel;
    [self.contentView addSubview:noMoreVoiceTipsLabel];

    self.subtitleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.voicebgView.frame.origin.y + self.voicebgView.frame.size.height + 11, 19, 19)];
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
    self.messageImageView = messageImageView;
    [self.contentView addSubview:messageImageView];
    
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(messageImageView.frame.origin.x + messageImageView.frame.size.width + 10, messageImageView.frame.origin.y, 64, 17)];
    self.messageLabel.text = @"互动(20)";
    self.messageLabel.textColor = baseblackColor;
    self.messageLabel.textAlignment = NSTextAlignmentLeft;
    self.messageLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.messageLabel];
    
    UIImageView * bookFriendsView = [[UIImageView alloc] initWithFrame:CGRectMake(self.messageLabel.frame.origin.x + self.messageLabel.frame.size.width + 25, self.messageLabel.frame.origin.y, 17, 17)];
    bookFriendsView.image = [UIImage imageNamed:@"fx_twoman"];
    self.bookFriendsView = bookFriendsView;
    [self.contentView addSubview:bookFriendsView];
    
    self.bookFriendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(bookFriendsView.frame.origin.x + bookFriendsView.frame.size.width + 10, bookFriendsView.frame.origin.y, 64, 17)];
    self.bookFriendsLabel.text = @"读友(85)";
    self.bookFriendsLabel.textColor = baseblackColor;
    self.bookFriendsLabel.textAlignment = NSTextAlignmentLeft;
    self.bookFriendsLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.bookFriendsLabel];
}

- (void)clickVoiceBtn:(UIButton *)btn{
    if (self.voiceBtnblock) {
        SR_BookClubNoteResourceModel * resourceModel  = self.resourceList[btn.tag - 100];
        self.voiceBtnblock(resourceModel.path);
    }
}

- (void)addVoicBtnblock:(noteDetailPageVoiceViewCellVoiceBtnBlock)block{
    self.voiceBtnblock = block;
}

- (void)clickInterBtn{
    if (self.interBtnBlock) {
        self.interBtnBlock();
    }
}

- (void)addInterBtnBlock:(noteDetailPageVoiceViewCellInterBtnBlock)block{
    self.interBtnBlock = block;
}

- (void)setNoteModel:(SR_BookClubBookNoteModel *)noteModel{
    _noteModel = noteModel;
    self.titleLabel.text = noteModel.title;
    NSDate * createData = [NSDate dateWithTimeIntervalSince1970:noteModel.time_create];
    NSString * time = [NSDate getRealDateTime:createData withFormat:@"yyyy-MM-dd HH:mm"];
    self.timeLabel.text = time;
    //    CGSize contentSize = [noteModel.content sizeForFont:[UIFont systemFontOfSize:14.0] size:CGSizeMake(kScreenWidth - 30, MAXFLOAT) mode:(NSLineBreakByWordWrapping)];
    //    self.voicebgView.frame = CGRectMake(15, self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height + 8, (int)contentSize.width, (int)contentSize.height + 10);
    
    for (UIView * sonView in self.voicebgView.subviews) {
        [sonView removeFromSuperview];
    }
    
    self.voicebgView.frame = CGRectMake(15, self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height + 8, (kScreenWidth - 30), (90)*noteModel.resourceList.count);
    
    if (self.resourceList.count) {
        self.voicebgView.hidden = NO;
        self.noMoreVoiceTipsLabel.hidden = YES;
    }else{
        self.voicebgView.hidden = YES;
        self.noMoreVoiceTipsLabel.hidden = NO;
    }
    
    for (int i = 0 ;i < self.resourceList.count; i ++) {
        
        UIView * barView = [[UIView alloc] initWithFrame:CGRectMake(0, 24 + i*(70 + 24), self.voicebgView.frame.size.width, 42)];
        barView.backgroundColor = kColor(215, 215, 215);
        barView.layer.cornerRadius = 21;
        [self.voicebgView addSubview:barView];
        
        UIButton * voiceBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        voiceBtn.frame = CGRectMake(0, 0, 70, 70);
        voiceBtn.center = CGPointMake((int)(barView.center.x), barView.center.y);
        voiceBtn.backgroundColor = baseColor;
        [voiceBtn setTitle:@"语音" forState:(UIControlStateNormal)];
        [voiceBtn setTitleColor:baseblackColor forState:(UIControlStateNormal)];
        voiceBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        voiceBtn.layer.cornerRadius = 35;
        [voiceBtn addTarget:self action:@selector(clickVoiceBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        voiceBtn.tag = i + 100;
        [self.voicebgView addSubview:voiceBtn];
        
        UIButton * deleteBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        deleteBtn.frame  = CGRectMake(0, 0, 30, 30);
        deleteBtn.center = CGPointMake(barView.frame.origin.x + barView.frame.size.width - 4, barView.frame.origin.y);
        deleteBtn.tag = i;
        [deleteBtn addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        deleteBtn.backgroundColor = [UIColor redColor];
        [self.voicebgView addSubview:deleteBtn];
        
        UIImageView * voiceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zbj_del"]];
        voiceImageView.frame = CGRectMake(0, 0, 17, 17);
        voiceImageView.center = deleteBtn.center;
        [self.voicebgView addSubview:voiceImageView];

    }
    
    
    if (!noteModel.page) {
        self.subtitleImageView.hidden = YES;
        self.subtitleButton.hidden = YES;
    }
    
    self.subtitleImageView.frame = CGRectMake(15, self.voicebgView.frame.origin.y + self.voicebgView.frame.size.height + 11, 19, 19);
    self.subtitleButton.frame = CGRectMake(self.subtitleImageView.frame.origin.x + self.subtitleImageView.frame.size.width + 5, self.subtitleImageView.frame.origin.y, 200, 19);
    self.messageImageView.frame = CGRectMake(15, self.subtitleButton.frame.origin.y + self.subtitleButton.frame.size.height + 10, 17, 17);
    self.messageLabel.frame = CGRectMake(self.messageImageView.frame.origin.x + self.messageImageView.frame.size.width + 10, self.messageImageView.frame.origin.y, 64, 17);
    self.bookFriendsView.frame = CGRectMake(self.messageLabel.frame.origin.x + self.messageLabel.frame.size.width + 25, self.messageLabel.frame.origin.y, 17, 17);
    self.bookFriendsLabel.frame =CGRectMake(self.bookFriendsView.frame.origin.x + self.bookFriendsView.frame.size.width + 10, self.bookFriendsView.frame.origin.y, 64, 17);
    
    
    [self.subtitleButton setTitle:noteModel.page.title forState:(UIControlStateNormal)];
    self.messageLabel.text = [NSString stringWithFormat:@"互动(%@)",noteModel.note_total];
    self.bookFriendsLabel.text = [NSString stringWithFormat:@"读友(%@)",noteModel.member_total];
    ;
}

- (void)clickDeleteBtn:(UIButton *)deleteBtn{
    if (self.deleteBtnBlock) {
        self.deleteBtnBlock(deleteBtn.tag);
    }
}

- (void)addDeleteBtnblock:(noteDetailPageVoiceViewCellDeleteBtnBlock)block{
    self.deleteBtnBlock = block;
}


@end
