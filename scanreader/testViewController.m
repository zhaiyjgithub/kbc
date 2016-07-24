//
//  testViewController.m
//  scanreader
//
//  Created by admin on 16/7/24.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "testViewController.h"
#import "SR_ActionSheetImageCollectionViewCell.h"
#import "SR_ActionSheetImageLayout.h"
#import "globalHeader.h"

static NSString *const cellID = @"DD_MyCollectionViewCell";

@interface testViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,weak)UICollectionView * collectionView;
@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupView];
}

- (void)setupView{
    SR_ActionSheetImageLayout * layout = [[SR_ActionSheetImageLayout alloc] init];
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = kColor(0xf3, 0xf3, 0xf3);
    [collectionView registerClass:[SR_ActionSheetImageCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SR_ActionSheetImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    return cell;
}


@end
