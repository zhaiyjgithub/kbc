//
//  SR_ActionSheetImageCollectionViewCell.h
//  scanreader
//
//  Created by admin on 16/7/24.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^longPressNoteImageViewBlock)(void);

@interface SR_ActionSheetImageCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView * noteImageView;
@property(nonatomic,strong)longPressNoteImageViewBlock block;
- (void)addBlock:(longPressNoteImageViewBlock)block;
@end
