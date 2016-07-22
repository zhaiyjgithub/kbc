//
//  SR_MineMessageSendDialogViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/7/22.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SR_MessageDialogLabel.h"
@interface SR_MineMessageSendDialogMineViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView * headerImageView;
@property(nonatomic,strong)SR_MessageDialogLabel * messageLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@end
