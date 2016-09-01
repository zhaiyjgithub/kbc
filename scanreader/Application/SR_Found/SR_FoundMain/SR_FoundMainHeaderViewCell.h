//
//  SR_FoundMainHeaderViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/9/1.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^foundMainHeaderViewCellBtnBlock)(NSInteger tag);

@interface SR_FoundMainHeaderViewCell : UITableViewCell
@property(nonatomic,assign)BOOL isSelectBookClub;
@property(nonatomic,strong)UIView * headerBgView;
@property(nonatomic,strong)foundMainHeaderViewCellBtnBlock block;
- (void)addBlock:(foundMainHeaderViewCellBtnBlock)block;
@end
