//
//  SR_MineViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SR_OAthouButton.h"

typedef void(^mineCellBlock)(UIButton *btn);

@interface SR_MineViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UILabel * levelabel;
@property(nonatomic,strong)UILabel * OAthuabel;
@property(nonatomic,assign)BOOL isSelectedOpen;
@property(nonatomic,strong)UIView * dotView;
@property(nonatomic,strong)mineCellBlock block;

- (void)addBlock:(mineCellBlock)block;
@end
