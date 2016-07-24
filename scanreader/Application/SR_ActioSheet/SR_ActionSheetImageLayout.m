//
//  SR_ActionSheetImageLayout.m
//  scanreader
//
//  Created by admin on 16/7/24.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_ActionSheetImageLayout.h"
#import "globalHeader.h"
#define kImageScale (1.5)

@implementation SR_ActionSheetImageLayout

-(id)init{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.numberOfColumns = 2;
        self.interItemSpacing = 5.0f; //设置左边距
        self.interItemBottomSpacing = 5.0f;//设置底部间距
        CGFloat interItemWidth = (kScreenWidth - 30 - (self.interItemSpacing * (self.numberOfColumns + 1)))/self.numberOfColumns;
        self.interItemHeight = (interItemWidth/kImageScale);
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds{
    return YES;
}

- (void)prepareLayout{
    [super prepareLayout];
    self.layoutYpos = [NSMutableDictionary dictionary];
    self.headerLayout = [NSMutableDictionary dictionary];
    
    CGFloat currentColum = 0;
    CGFloat interItemWidth = (kScreenWidth - 30 - (self.interItemSpacing * (self.numberOfColumns + 1)))/self.numberOfColumns;
    self.layoutAttributes = [NSMutableDictionary dictionary];
    NSInteger numOfSection = [self.collectionView numberOfSections];
    for (int i = 0 ; i < numOfSection; i ++) {
        NSInteger numOfItems = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j < numOfItems; j ++) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            //获取每个分组中每个cell的layout属性
            UICollectionViewLayoutAttributes * itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            CGFloat x = self.interItemSpacing + (self.interItemSpacing + interItemWidth) * currentColum;
            CGFloat y = [self.layoutYpos[@(currentColum)] doubleValue];//其实第0个总是0，后面再填充该该字典
            if (j == 0 || j == 1) y = 5.0f;
            itemAttributes.frame = CGRectMake(x, y, interItemWidth, self.interItemHeight);
            y += self.interItemHeight;
            y += self.interItemBottomSpacing;// 这里设置cell的上下间距
            self.layoutYpos[@(currentColum)] = @(y);
            currentColum +=1;
            if (currentColum == self.numberOfColumns) currentColum = 0;
            self.layoutAttributes[indexPath] = itemAttributes;
        }
    }
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray * allAttributes = [[NSMutableArray alloc] initWithCapacity:self.layoutAttributes.count+1];
    [self.layoutAttributes enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexpath, UICollectionViewLayoutAttributes * attributes, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [allAttributes addObject:attributes];
        }
    }];
    return allAttributes;
}

- (CGSize)collectionViewContentSize{
    CGFloat interItemWidth = (kScreenWidth - 30 - (self.interItemSpacing * (self.numberOfColumns + 1)))/self.numberOfColumns;
    CGFloat interItemHeight = (interItemWidth/kImageScale);
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    return CGSizeMake(kScreenWidth - 30, (numberOfItems/2)*(self.interItemBottomSpacing + interItemHeight) + (numberOfItems%2)*(interItemHeight + self.interItemBottomSpacing) + 15);
}

@end
