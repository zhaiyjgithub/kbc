//
//  SR_NoteDetailPageImageViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/8/28.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_NoteDetailPageImageViewCell.h"
#import "globalHeader.h"
#import "NSDate+JJ.h"
#import "NSString+JJ.h"


@implementation SR_NoteDetailPageImageViewCell

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
    
    self.imagebgView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 280)/2, self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height + 8,280, 280 + 10)];
    self.imagebgView.backgroundColor = [UIColor whiteColor];
    self.imagebgView.hidden = YES;
    [self.contentView addSubview:self.imagebgView];
    
    UILabel * noMoreVoiceTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.imagebgView.frame.origin.y, self.imagebgView.frame.size.width, 16)];
    noMoreVoiceTipsLabel.text = @"没有更多图片笔记，点击右上角添加图片笔记";
    noMoreVoiceTipsLabel.textColor = [UIColor lightGrayColor];
    noMoreVoiceTipsLabel.font = [UIFont systemFontOfSize:14.0];
    noMoreVoiceTipsLabel.textAlignment = NSTextAlignmentLeft;
    noMoreVoiceTipsLabel.numberOfLines = 0;
    self.noMoreVoiceTipsLabel = noMoreVoiceTipsLabel;
    [self.contentView addSubview:noMoreVoiceTipsLabel];
    
    self.subtitleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.imagebgView.frame.origin.y + self.imagebgView.frame.size.height + 11, 19, 19)];
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

- (void)clickInterBtn{
    if (self.interBtnBlock) {
        self.interBtnBlock();
    }
}

- (void)addInterBtnBlock:(noteDetailPageImageViewCellInterBtnBlock)block{
    self.interBtnBlock = block;
}

- (void)setNoteModel:(SR_BookClubBookNoteModel *)noteModel{
    _noteModel = noteModel;
    self.titleLabel.text = noteModel.title;
    NSDate * createData = [NSDate dateWithTimeIntervalSince1970:noteModel.time_create];
    NSString * time = [NSDate compareCurrentTime:createData];//[NSDate getRealDateTime:createData withFormat:@"yyyy-MM-dd HH:mm"];
    NSString * nameAndTime = [NSString stringWithFormat:@"%@ %@",noteModel.user.username,time];
    NSMutableAttributedString * attributesString = [[NSMutableAttributedString alloc] initWithString:nameAndTime];
    [attributesString addAttribute:NSForegroundColorAttributeName value:kColor(0x20, 0x20, 0x20) range:NSMakeRange(0, noteModel.user.username.length)];
    [attributesString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(noteModel.user.username.length, nameAndTime.length - noteModel.user.username.length)];
    self.timeLabel.attributedText = attributesString;

    for (UIView * sonView in self.imagebgView.subviews) {
        [sonView removeFromSuperview];
    }
    self.imagebgView.frame = CGRectMake((kScreenWidth - 280)/2, self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height + 8, 280, (280 + 10)*noteModel.resourceList.count);
    if (self.resourceList.count) {
        self.imagebgView.hidden = NO;
        self.noMoreVoiceTipsLabel.hidden = YES;
    }else{
        self.imagebgView.hidden = YES;
        self.noMoreVoiceTipsLabel.hidden = NO;
    }
    
    for (int i = 0 ;i < self.resourceList.count; i ++) {
        SR_BookClubNoteResourceModel * resourceModel = self.resourceList[i];
        YYAnimatedImageView * resouceImageView = [[YYAnimatedImageView alloc] init];
        resouceImageView.frame = CGRectMake(0, i*(280 + 10), 280, 280);
        [resouceImageView setImageWithURL:[NSURL URLWithString:resourceModel.path] placeholder:nil];
        resouceImageView.userInteractionEnabled = YES;
        resouceImageView.tag = 100 + i;
        resouceImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.imagebgView addSubview:resouceImageView];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPreScanBtn:)];
        [resouceImageView addGestureRecognizer:tapGesture];
        
        UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickDeleteBtn:)];
        longPressGesture.minimumPressDuration = 1.5;
        [resouceImageView addGestureRecognizer:longPressGesture];
    }
    if (!noteModel.page) {
        self.subtitleImageView.hidden = YES;
        self.subtitleButton.hidden = YES;
    }
    
    self.subtitleImageView.frame = CGRectMake(15, self.imagebgView.frame.origin.y + self.imagebgView.frame.size.height + 11, 19, 19);
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

- (void)clickDeleteBtn:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (self.deleteBtnBlock) {
            self.deleteBtnBlock(gesture.view.tag);
        }
    }else{
      //  NSLog(@"--%d",gesture.state);
    }
}

- (void)addDeleteBtnblock:(noteDetailPageImageViewCellDeleteBtnBlock)block{
    self.deleteBtnBlock = block;
}

- (void)clickPreScanBtn:(UITapGestureRecognizer *)gesture{
    if (self.preScanViewBlock) {
        self.preScanViewBlock(gesture.view.tag);
    }
}

- (void)addPreScanViewBlock:(noteDetailPageImageViewCellPreScanViewBtnBlock)block{
    self.preScanViewBlock = block;
}


@end
