//
//  SR_FoundMainDynamicViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/7/21.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_FoundMainDynamicViewCell.h"
#import "globalHeader.h"

@implementation SR_FoundMainDynamicViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell{
    self.bookImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(15, 15, 75, 93)];
    self.bookImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.bookImageView];
    
    self.bookNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bookImageView.frame.origin.x + self.bookImageView.frame.size.width + 15, 30, kScreenWidth - 30 - 15 - self.bookImageView.frame.size.width - 20, 15)];
    self.bookNameLabel.text = @"论语";
    self.bookNameLabel.textColor = baseblackColor;
    self.bookNameLabel.textAlignment = NSTextAlignmentLeft;
    self.bookNameLabel.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:self.bookNameLabel];
    
    self.bookAuthorLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bookNameLabel.frame.origin.x, self.bookNameLabel.frame.origin.y + self.bookNameLabel.frame.size.height + 10, self.bookNameLabel.frame.size.width, 15)];
    self.bookAuthorLabel.text = @"作者:孔子";
    self.bookAuthorLabel.textColor = baseblackColor;
    self.bookAuthorLabel.textAlignment = NSTextAlignmentLeft;
    self.bookAuthorLabel.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:self.bookAuthorLabel];
    
    UIImageView * messageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bookAuthorLabel.frame.origin.x, self.bookAuthorLabel.frame.origin.y + self.bookAuthorLabel.frame.size.height + 10, 17, 17)];
    messageImageView.image = [UIImage imageNamed:@"fx_hd"];
    [self.contentView addSubview:messageImageView];
    
    self.bookMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(messageImageView.frame.origin.x + messageImageView.frame.size.width + 10, messageImageView.frame.origin.y, 64, 17)];
    self.bookMessageLabel.text = @"互动(0)";
    self.bookMessageLabel.textColor = baseblackColor;
    self.bookMessageLabel.textAlignment = NSTextAlignmentLeft;
    self.bookMessageLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.bookMessageLabel];
    
    UIImageView * bookFriendsView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bookMessageLabel.frame.origin.x + self.bookMessageLabel.frame.size.width + 20, self.bookMessageLabel.frame.origin.y, 17, 17)];
    bookFriendsView.image = [UIImage imageNamed:@"fx_twoman"];
    [self.contentView addSubview:bookFriendsView];
    
    self.bookFriendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(bookFriendsView.frame.origin.x + bookFriendsView.frame.size.width + 10, bookFriendsView.frame.origin.y, 64, 17)];
    self.bookFriendsLabel.text = @"读友(0)";
    self.bookFriendsLabel.textColor = baseblackColor;
    self.bookFriendsLabel.textAlignment = NSTextAlignmentLeft;
    self.bookFriendsLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.bookFriendsLabel];
}

- (void)setBookModel:(SR_BookClubBookModel *)bookModel{
    _bookModel = bookModel;
    [self.bookImageView setImageWithURL:[NSURL URLWithString:bookModel.picture] placeholder:nil];
    self.bookNameLabel.text = bookModel.title;
    self.bookAuthorLabel.text = [NSString stringWithFormat:@"作者:%@",bookModel.author];
    self.bookMessageLabel.text = [NSString stringWithFormat:@"互动(%@)",bookModel.note_total];
    self.bookFriendsLabel.text = [NSString stringWithFormat:@"读友(%@)",bookModel.member_total];
}

@end
