//
//  SR_NoteDetailPageTextViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/8/28.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_NoteDetailPageTextViewCell.h"
#import "globalHeader.h"
#import "NSDate+JJ.h"
#import "NSString+JJ.h"

@implementation SR_NoteDetailPageTextViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth - 30, 17)];
    self.titleLabel.text = @"笔记标题";
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 8,120,16)];
    self.timeLabel.text = @"2016-06-28 12:30";
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.timeLabel];
    
    self.bodyTextLabel = [[UILabel alloc] init];
    self.bodyTextLabel.frame = CGRectMake(15, self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height + 8, kScreenWidth - 30 - 10 - 48, 39);
    self.bodyTextLabel.backgroundColor = [UIColor whiteColor];
    self.bodyTextLabel.text = @"content...";
    self.bodyTextLabel.numberOfLines = 0;
    self.bodyTextLabel.textColor = [UIColor lightGrayColor];
    self.bodyTextLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.bodyTextLabel];
    
    self.subtitleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.bodyTextLabel.frame.origin.y + self.bodyTextLabel.frame.size.height + 11, 19, 19)];
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

- (void)addInterBtnBlock:(noteDetailPageTextViewCellInterBlock)block{
    self.interBtnBlock = block;
}

- (void)setNoteModel:(SR_BookClubBookNoteModel *)noteModel{
    _noteModel = noteModel;
    self.titleLabel.text = noteModel.title;
    NSDate * createData = [NSDate dateWithTimeIntervalSince1970:noteModel.time_create];
    NSString * time = [NSDate compareCurrentTime:createData];// [NSDate getRealDateTime:createData withFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString * nameAndTime = [NSString stringWithFormat:@"%@ %@",_noteModel.user.username,time];
    NSMutableAttributedString * attributesString = [[NSMutableAttributedString alloc] initWithString:nameAndTime];
    [attributesString addAttribute:NSForegroundColorAttributeName value:kColor(0x20, 0x20, 0x20) range:NSMakeRange(0, _noteModel.user.username.length)];
    [attributesString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(noteModel.user.username.length, nameAndTime.length - noteModel.user.username.length)];
    self.timeLabel.attributedText = attributesString;
    
    CGSize contentSize = [noteModel.content sizeForFont:[UIFont systemFontOfSize:14.0] size:CGSizeMake(kScreenWidth - 30, MAXFLOAT) mode:(NSLineBreakByWordWrapping)];
    self.bodyTextLabel.frame = CGRectMake(15, self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height + 8, (int)contentSize.width + 1, (int)contentSize.height + 10);
    self.bodyTextLabel.text = noteModel.content;
    
    self.subtitleImageView.frame = CGRectMake(15, self.bodyTextLabel.frame.origin.y + self.bodyTextLabel.frame.size.height + 11, 19, 19);
    self.subtitleButton.frame = CGRectMake(self.subtitleImageView.frame.origin.x + self.subtitleImageView.frame.size.width + 5, self.subtitleImageView.frame.origin.y, 200, 19);
    self.messageImageView.frame = CGRectMake(15, self.subtitleButton.frame.origin.y + self.subtitleButton.frame.size.height + 10, 17, 17);
    self.messageLabel.frame = CGRectMake(self.messageImageView.frame.origin.x + self.messageImageView.frame.size.width + 10, self.messageImageView.frame.origin.y, 64, 17);
    self.bookFriendsView.frame = CGRectMake(self.messageLabel.frame.origin.x + self.messageLabel.frame.size.width + 25, self.messageLabel.frame.origin.y, 17, 17);
    self.bookFriendsLabel.frame =CGRectMake(self.bookFriendsView.frame.origin.x + self.bookFriendsView.frame.size.width + 10, self.bookFriendsView.frame.origin.y, 64, 17);
    
    self.messageLabel.text = [NSString stringWithFormat:@"互动(%@)",noteModel.note_total];
    self.bookFriendsLabel.text = [NSString stringWithFormat:@"读友(%@)",noteModel.member_total];
    
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
}

@end
