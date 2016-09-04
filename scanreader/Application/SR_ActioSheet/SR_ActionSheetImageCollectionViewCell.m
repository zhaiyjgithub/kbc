//
//  SR_ActionSheetImageCollectionViewCell.m
//  scanreader
//
//  Created by admin on 16/7/24.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_ActionSheetImageCollectionViewCell.h"

@implementation SR_ActionSheetImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor blueColor];
        self.noteImageView = [[UIImageView alloc] init];
        self.noteImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.noteImageView.userInteractionEnabled = YES;
        //self.noteImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.noteImageView];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPressNoteImageView)];
        [self.noteImageView addGestureRecognizer:tapGesture];
    }
    
    return self;
}

- (void)longPressNoteImageView{
    if (self.block) {
        self.block();
    }
}

- (void)addBlock:(longPressNoteImageViewBlock)block{
    self.block = block;
}

@end
