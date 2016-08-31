//
//  SR_InterPageDetailTextViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/8/31.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_InterPageDetailTextViewCell.h"
#import "globalHeader.h"

@implementation SR_InterPageDetailTextViewCell

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
}

- (void)setTextFrameModel:(SR_InterPageTextFrameModel *)textFrameModel{
    _textFrameModel = textFrameModel;
    self.titleLabel.text = textFrameModel.MoudleListItemModel.title;
    self.contentLabel.frame = CGRectMake(15, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 8, kScreenWidth - 30, textFrameModel.contentHeight + 10);
    self.contentLabel.text = textFrameModel.MoudleListItemModel.content;
}
@end
