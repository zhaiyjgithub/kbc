//
//  SR_FoundMainCollectionViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_FoundMainCollectionViewCell.h"
#import "globalHeader.h"
#import "NSString+JJ.h"
#import "NSDate+JJ.h"

@implementation SR_FoundMainCollectionViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell{
    UIImageView * collectionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jl_sc"]];
    collectionImageView.frame = CGRectMake(15, 15, 19, 19);
    [self.contentView addSubview:collectionImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 + 19 + 10, 15, 33, 19)];
    self.titleLabel.text = @"收藏";
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 15,15,120,19)];
    self.timeLabel.text = @"2016-06-28 12:30";
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.timeLabel];
    
    self.subtitleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height + 16, 19, 19)];
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
    self.headerImageView.frame = CGRectMake(0, 0, 48, 48);
    self.headerImageView.center = CGPointMake(kScreenWidth - 36, 54);
    self.headerImageView.layer.cornerRadius = 24;
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.headerImageView];
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeaderBtn)];
    self.headerImageView.userInteractionEnabled = YES;
    [self.headerImageView addGestureRecognizer:gesture];
    
}   // Configure the view for the selected state、

- (void)setNoteModel:(SR_BookClubBookNoteModel *)noteModel{
    _noteModel = noteModel;
    NSDate * createData = [NSDate dateWithTimeIntervalSince1970:noteModel.time_create];
    NSString * time = [NSDate getRealDateTime:createData withFormat:@"yyyy-MM-dd HH:mm"];
    self.timeLabel.text = time;
    [self.subtitleButton setTitle:noteModel.page.title forState:(UIControlStateNormal)];
    self.messageLabel.text = [NSString stringWithFormat:@"互动(%@)",noteModel.note_total];
    self.bookFriendsLabel.text = [NSString stringWithFormat:@"读友(%@)",noteModel.member_total];
    [self.headerImageView setImageWithURL:[NSURL URLWithString:noteModel.user.avatar] placeholder:[UIImage imageNamed:@"headerIcon"]];
    if (!noteModel.page) {
        self.subtitleImageView.hidden = YES;
        self.subtitleButton.hidden = YES;
    }
}

- (void)clickHeaderBtn{
    SSLog(@"click header btn");
    if (self.block) {
        self.block();
    }
}

- (void)addBlock:(foundMainCollectionViewCellBlock)block{
    self.block = block;
}

- (void)clickInterBtn{
    if (self.interBlock) {
        self.interBlock();
    }
}

- (void)addInterBlock:(foundMainCollectionViewCellInterBlock)interBlock{
    self.interBlock = interBlock;
}


@end
