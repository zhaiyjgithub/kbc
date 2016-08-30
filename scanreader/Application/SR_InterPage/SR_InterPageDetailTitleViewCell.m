//
//  SR_InterPageDetailTitleViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/8/30.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_InterPageDetailTitleViewCell.h"
#import "globalHeader.h"

@implementation SR_InterPageDetailTitleViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, (kScreenWidth - 30), 15)];
    self.titleLabel.text = @"笔记标题";
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.frame = CGRectMake(15, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 8, kScreenWidth - 30 - 10 - 48, 39);
    self.contentLabel.backgroundColor = [UIColor whiteColor];
    self.contentLabel.text = @"content...";
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textColor = [UIColor lightGrayColor];
    self.contentLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.contentLabel];
    
    UIImageView * messageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + 10, 17, 17)];
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

- (void)setTitleFrameModel:(SR_InterPageTitleFrameModel *)titleFrameModel{
    _titleFrameModel = titleFrameModel;
    self.titleLabel.text = titleFrameModel.detailItemModel.title;

    self.contentLabel.frame = CGRectMake(15, self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height + 8, kScreenWidth - 30 - 10 - 48, titleFrameModel.contentHeight + 10);
    self.contentLabel.text = titleFrameModel.detailItemModel.content;
    
    self.messageImageView.frame = CGRectMake(15, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + 10, 17, 17);
    self.messageLabel.frame = CGRectMake(self.messageImageView.frame.origin.x + self.messageImageView.frame.size.width + 10, self.messageImageView.frame.origin.y, 64, 17);
    self.bookFriendsView.frame = CGRectMake(self.messageLabel.frame.origin.x + self.messageLabel.frame.size.width + 25, self.messageLabel.frame.origin.y, 17, 17);
    self.bookFriendsLabel.frame =CGRectMake(self.bookFriendsView.frame.origin.x + self.bookFriendsView.frame.size.width + 10, self.bookFriendsView.frame.origin.y, 64, 17);
    
    self.messageLabel.text = [NSString stringWithFormat:@"互动(%@)",titleFrameModel.detailItemModel.note_total];
    self.bookFriendsLabel.text = [NSString stringWithFormat:@"读友(%@)",titleFrameModel.detailItemModel.member_total];
}


@end
