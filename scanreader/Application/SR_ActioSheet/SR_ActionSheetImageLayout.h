//
//  SR_ActionSheetImageLayout.h
//  scanreader
//
//  Created by admin on 16/7/24.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SR_ActionSheetImageLayout : UICollectionViewFlowLayout
@property(nonatomic,strong)NSMutableDictionary * layoutAttributes;
@property(nonatomic,strong)NSMutableDictionary * layoutYpos;
@property (nonatomic, assign) NSUInteger numberOfColumns;
@property (nonatomic, assign) CGFloat interItemSpacing;
@property(nonatomic,assign)CGFloat interItemBottomSpacing;
@property(nonatomic,assign)CGFloat interItemHeight;
//@property (weak, nonatomic)  id<CustomCollectionViewLayoutDelegate> delegate;
@property(nonatomic,strong)NSMutableDictionary * headerLayout;
@property(nonatomic,strong)NSMutableDictionary * footerLayout;
@end
