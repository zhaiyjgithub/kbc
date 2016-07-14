//
//  SR_MineMessageHeaderInfoViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/7/14.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^mineMessageHeaderInfoViewCellBlock)(void);

@interface SR_MineMessageHeaderInfoViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView * headerIcon;
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)mineMessageHeaderInfoViewCellBlock block;
- (void)addBlock:(mineMessageHeaderInfoViewCellBlock)block;
@end
