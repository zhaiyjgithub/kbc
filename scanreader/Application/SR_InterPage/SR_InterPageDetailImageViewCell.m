//
//  SR_InterPageDetailImageViewCell.m
//  scanreader
//
//  Created by jbmac01 on 16/8/31.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_InterPageDetailImageViewCell.h"
#import "globalHeader.h"
#import "NSDate+JJ.h"
#import "NSString+JJ.h"


@implementation SR_InterPageDetailImageViewCell

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
    
    self.imagebgView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 280)/2, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 8,280, 280 + 10)];
    self.imagebgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:self.imagebgView];
}

- (void)clickInterBtn{
    SSLog(@"click inter btn");
}

- (void)setTextFrameModel:(SR_InterPageTextFrameModel *)textFrameModel{
    _textFrameModel = textFrameModel;
    self.titleLabel.text = textFrameModel.MoudleListItemModel.title;
    
    for (UIView * sonView in self.imagebgView.subviews) {
        [sonView removeFromSuperview];
    }
    self.imagebgView.frame = CGRectMake((kScreenWidth - 280)/2, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 8, 280, (280 + 10)*textFrameModel.MoudleListItemModel.photoList.count);
    
    for (int i = 0;i < textFrameModel.MoudleListItemModel.photoList.count; i ++) {
        SR_InterPageDetailItemMoudleListItemPhotoListItemModel * photoModel = [SR_InterPageDetailItemMoudleListItemPhotoListItemModel modelWithDictionary:textFrameModel.MoudleListItemModel.photoList[i]];
        
        YYAnimatedImageView * resouceImageView = [[YYAnimatedImageView alloc] init];
        resouceImageView.frame = CGRectMake(0, i*(280 + 10), 280, 280);
        NSString * url = [NSString stringWithFormat:@"%@%@",BASE_URL,photoModel.pic];
        NSLog(@"path:%@",url);
        [resouceImageView setImageWithURL:[NSURL URLWithString:url] placeholder:nil];
        [self.imagebgView addSubview:resouceImageView];
    }
}


@end
