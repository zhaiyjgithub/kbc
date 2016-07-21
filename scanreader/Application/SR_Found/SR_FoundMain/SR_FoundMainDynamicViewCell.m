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
    self.bookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 75, 93)];
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
    
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(messageImageView.frame.origin.x + messageImageView.frame.size.width + 10, messageImageView.frame.origin.y, 64, 17)];
    self.messageLabel.text = @"互动(20)";
    self.messageLabel.textColor = baseblackColor;
    self.messageLabel.textAlignment = NSTextAlignmentLeft;
    self.messageLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.messageLabel];
    
    UIImageView * bookFriendsView = [[UIImageView alloc] initWithFrame:CGRectMake(self.messageLabel.frame.origin.x + self.messageLabel.frame.size.width + 20, self.messageLabel.frame.origin.y, 17, 17)];
    bookFriendsView.image = [UIImage imageNamed:@"fx_twoman"];
    [self.contentView addSubview:bookFriendsView];
    
    self.bookFriendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(bookFriendsView.frame.origin.x + bookFriendsView.frame.size.width + 10, bookFriendsView.frame.origin.y, 64, 17)];
    self.bookFriendsLabel.text = @"读友(85)";
    self.bookFriendsLabel.textColor = baseblackColor;
    self.bookFriendsLabel.textAlignment = NSTextAlignmentLeft;
    self.bookFriendsLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.bookFriendsLabel];
}

@end
